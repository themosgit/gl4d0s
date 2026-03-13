# modules/system/networking.nix
{ config, pkgs, ... }:

{
  sops.secrets.ddns-env = {
    sopsFile = ../../secrets/ddns-env;
    format = "binary";
    owner = "root";
  };

  networking = {
    hostName = "gl4d0s";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ ];
    };
  };

  systemd.services.update-ddns = {
    description = "Cloudflare DDNS Updater";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    path = with pkgs; [
      bash
      curl
      util-linux
    ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash /etc/nixos/modules/ddns/updater.sh";
      EnvironmentFile = config.sops.secrets.ddns-env.path;
      User = "root";
    };
  };

  systemd.timers.update-ddns = {
    description = "Run DDNS Updater every 5 minutes";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnBootSec = "30sec";
      OnUnitActiveSec = "5min";
      Persistent = true;
      Unit = "update-ddns.service";
    };
  };

  services.resolved.enable = true;

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";
    bantime-increment = {
      enable = true;
      formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      maxtime = "4320";
      overalljails = true;
    };
    jails = {
      nginx-api-abuse.settings = {
        enabled = true;
        filter = "nginx-http-auth";
        logpath = "/var/log/nginx/api_access.log";
        backend = "auto";
        port = "http,https";
      };
      apache-nohome-iptables.settings = {
        filter = "apache-nohome";
        action = ''iptables-multiport[name=HTTP, port="http,https]"'';
        logpath = "/var/log/httpd/error_log*";
        backend = "auto";
        findtime = 600;
        bantime = 600;
        maxretry = 5;
      };
    };
  };
}
