{ config, pkgs, ... }:

{
  imports = [
    ./hydra.nix
    ./niks3.nix
  ];

  nix.settings = {
    max-jobs = 16;
    min-free = 50 * 1024 * 1024 * 1024;
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
