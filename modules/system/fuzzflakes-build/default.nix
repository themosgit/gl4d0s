{ config, pkgs, lib, ... }:

{
  imports = [
    ./hydra.nix
    ./niks3.nix
  ];

  nix.settings = {
    max-jobs = 16;
    builders-use-substitutes = true;
    narinfo-cache-positive-ttl = 3600;
    narinfo-cache-negative-ttl = 1800;
    max-substitution-jobs = 32;
    http-connections = 50;
    auto-optimise-store = true;
    connect-timeout = 10;
  };

  nix.gc = {
    automatic = true;
    dates = "hourly";
    options = "--delete-older-than 7d";
  };

  #this is a hole accept-new should be changed to PAT
  programs.ssh.extraConfig = ''
    Host github.com
      User git
      IdentityFile ${config.sops.secrets.hydra-github-ssh.path}
      StrictHostKeyChecking accept-new
  '';

  services.postgresql = {
    enable = true;
    enableTCPIP = false;
    settings = {
        shared_buffers = "1GB";
        effective_cache_size = "4GB";
        work_mem = "16MB";
        maintenance_work_mem = "256MB";
        max_connections = 200;
        random_page_cost = 1.1;
        effective_io_concurrency = 200;
        wal_buffers = "16MB";
        checkpoint_completion_target = 0.9; 
        max_wal_size = "1GB";
    };
  };

  sops.secrets.cloudflared-hydra = {
    sopsFile = ../../../secrets/cloudflared-hydra;
    format = "binary";
    owner = "cloudflared";
    group = "cloudflared";
  };

  users.users.cloudflared = {
    isSystemUser = true;
    group = "cloudflared";
  };
  users.groups.cloudflared = { };

  services.cloudflared = {
    enable = true;
    tunnels.hydra = {
      credentialsFile = config.sops.secrets.cloudflared-hydra.path;
      default = "http_status:404";
      ingress = {
        "hydra.gl4dos.com" = "http://localhost:3000";
      };
    };
  };
}
