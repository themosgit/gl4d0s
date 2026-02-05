{ config, pkgs, lib, ... }:

let
  domainName = "gl4dos.com";
  ollamaPort = 11434;
  litellmPort = 4000;
  redisPort = 6379;
in {

  age.secrets.litellm-env = {
    file = ../secrets/litellm-env.age;
    mode = "0400";
    owner = "litellm";
    group = "litellm";
  };

  age.secrets.redis-pass = {
    file = ../secrets/redis-pass.age;
    mode = "0400";
    owner = "redis-litellm";
    group = "redis-litellm";
  };

  age.secrets.cloudflare-token = {
      file = ../secrets/cloudflare-token.age;
      mode = "0400";
      group = "acme";
  };

  services.postgresql = {
      enable = true;
      ensureDatabases = [ "litellm" ];
      ensureUsers = [{
          name = "litellm";
          ensureDBOwnership = true;
      }];
      authentication = ''
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      host    litellm         litellm         127.0.0.1/32            trust
    '';
  };

  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    rocmOverrideGfx = "9.0.0";

    environmentVariables = {
        "HSA_ENABLE_SDMA" = "0";
    };
    host = "0.0.0.0";
    port = ollamaPort;

  };

  systemd.services.ollama.serviceConfig = {
    MemoryMax = "16G";
    CPUQuota = "400%";
    NoNewPrivileges = true;
    PrivateTmp = true;
    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelTunables = true;
    ProtectControlGroups = true;
    RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
    RestrictSUIDSGID = true;
    ReadWritePaths = [ "/var/lib/ollama" ];
  };

  services.redis.servers.litellm = {
    enable = true;
    port = redisPort;
    bind = "127.0.0.1";
    requirePassFile = config.age.secrets.redis-pass.path;
    appendOnly = true;
  };

  users.users.litellm = {
    isSystemUser = true;
    group = "litellm";
    home = "/var/lib/litellm";
    createHome = true;
  };
  users.groups.litellm = {};

virtualisation.oci-containers.containers.litellm = {
  image = "ghcr.io/berriai/litellm:main-latest";
  extraOptions = [ "--network=host" ]; 

  environmentFiles = [ config.age.secrets.litellm-env.path ];

  environment = {
      "PYTHONUNBUFFERED" = "1";
  };

  volumes = [
    "/etc/litellm/config.yaml:/app/config.yaml"
    "/var/lib/litellm-docker:/app/data"
  ];

  cmd = [ "--config" "/app/config.yaml" "--port" "${toString litellmPort}" "--host" "127.0.0.1" ];
};

systemd.tmpfiles.rules = [
  "d /var/lib/litellm-docker 0755 root root -"
];
  environment.etc."litellm/config.yaml".text = ''
    model_list:
      - model_name: gpt-4
        litellm_params:
          model: ollama/ministral-3:8b
          api_base: http://127.0.0.1:${toString ollamaPort}
      
      - model_name: gpt-3.5-turbo
        litellm_params:
          model: ollama/qwen2.5-coder:7b
          api_base: http://127.0.0.1:${toString ollamaPort}

    general_settings:
      master_key: os.environ/LITELLM_MASTER_KEY
    
    litellm_settings:
      json_logs: true
      cache: true
      cache_params:
        type: "redis"
        host: os.environ/REDIS_HOST
        port: os.environ/REDIS_PORT
        password: os.environ/REDIS_PASSWORD
  '';
  security.acme = {
    acceptTerms = true;
    defaults.email = "themos360@gmail.com";
    certs."gl4dos.com" = {
        domain = "gl4dos.com";
        dnsProvider = "cloudflare";
        credentialsFile = config.age.secrets.cloudflare-token.path;
        group = "nginx"; 
    };
  };
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    sslProtocols = "TLSv1.3";

    commonHttpConfig = ''
      limit_req_zone $binary_remote_addr zone=api_limit:10m rate=15r/s;
      limit_conn_zone $binary_remote_addr zone=addr_limit:10m;
      
      log_format security_audit '$remote_addr - $remote_user [$time_local] '
                                '"$request" $status $body_bytes_sent '
                                '"$http_referer" "$http_user_agent"';
    '';

    virtualHosts."${domainName}" = {
      forceSSL = true;
      useACMEHost = "gl4dos.com";
      
      extraConfig = ''
        access_log /var/log/nginx/api_access.log security_audit;
      '';

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString litellmPort}";
        proxyWebsockets = true;
        
        extraConfig = ''
          limit_req zone=api_limit burst=30000 nodelay;
          limit_conn addr_limit 10;
          
          proxy_hide_header X-Powered-By;
          proxy_hide_header Server;
          add_header X-Frame-Options DENY;
          add_header X-Content-Type-Options nosniff;
          
          proxy_read_timeout 600s;
          proxy_send_timeout 600s;
          
          proxy_buffering off;
        '';
      };
    };
  };
 }
