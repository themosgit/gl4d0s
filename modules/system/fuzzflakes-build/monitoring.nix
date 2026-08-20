{ config, ... }:

{
  sops.secrets.prometheus-web-config = {
    sopsFile = ../../../secrets/prometheus-web-config;
    format = "binary";
    owner = "prometheus";
    group = "prometheus";
    mode = "0400";
  };

  sops.secrets.grafana-admin-password = {
    sopsFile = ../../../secrets/grafana-admin-password;
    format = "binary";
    owner = "grafana";
    group = "grafana";
    mode = "0400";
  };

  sops.secrets.grafana-secret-key = {
    sopsFile = ../../../secrets/grafana-secret-key;
    format = "binary";
    owner = "grafana";
    group = "grafana";
    mode = "0400";
  };

  services.prometheus = {
    enable = true;
    listenAddress = "127.0.0.1";
    port = 9090;

    globalConfig = {
      scrape_interval = "15s";
    };

    scrapeConfigs = [
      {
        job_name = "niks3";
        static_configs = [ { targets = [ "127.0.0.1:5751" ]; } ];
      }
      {
        job_name = "node";
        static_configs = [ { targets = [ "127.0.0.1:9100" ]; } ];
      }
    ];

    exporters.node = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = 9100;
      enabledCollectors = [ "systemd" ];
    };

    webConfigFile = config.sops.secrets.prometheus-web-config.path;
  };

  services.grafana = {
    enable = true;

    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
        domain = "grafana.gl4dos.com";
        root_url = "https://grafana.gl4dos.com";
      };
      security = {
        admin_user = "admin";
        admin_password = "$__file{${config.sops.secrets.grafana-admin-password.path}}";
        secret_key = "$__file{${config.sops.secrets.grafana-secret-key.path}}";
      };
      analytics.reporting_enabled = false;
    };

    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://127.0.0.1:9090";
          isDefault = true;
        }
      ];
    };
  };
}
