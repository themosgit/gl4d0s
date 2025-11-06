# modules/system/networking.nix
{ config, pkgs, ... }:

{
  networking = {
    hostName = "gl4d0s";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [];
    };
  };

  systemd.services.update-ddns = {
      serviceConfig = {
          EnvironmentFile = "/etc/nixos/ddns/.env";
          ExecStart = "/etc/nixos/modules/ddns/updater.sh";
          WorkingDirectory = "/etc/nixos/modules/ddns";
          Type = "oneshot";
      };
  };

  systemd.timers.update-ddns = {
      wantedBy = ["timers.target"];
      timerConfig = {
          onCalendar = "*-*-* 08:00:00";
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
      maxretry = 4;
      bantime = "24h";
      bantime-increment = {
          enable = true;
          formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      maxtime = "4320"; # Do not ban for more than 1 week
      overalljails = true; # Calculate the bantime based on all the violation
      };
      jails = {
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
