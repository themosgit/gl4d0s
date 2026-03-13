{ pkgs, config, ... }:
let
  postBuildHook = pkgs.writeShellScript "attic-post-build-hook" ''
    set -euf
    export HOME=/root
    TOKEN=$(cat ${config.age.secrets.attic-hydra-token.path})
    ${pkgs.attic-client}/bin/attic login local http://localhost:8080 "$TOKEN" 2>/dev/null || true
    ${pkgs.attic-client}/bin/attic push fuzzflakes $OUT_PATHS
  '';
in
{
  age.secrets = {
    cloudflared-hydra = {
        file = ../../secrets/cloudflared-hydra.age;
        owner = "cloudflared";
        group = "cloudflared";
    };
    attic-hydra-token = {
        file = ../../secrets/attic-hydra-token.age;
    };
    hydra-github-ssh = {
        file = ../../secrets/hydra-github-ssh.age;
        owner = "hydra";
        group = "hydra";
        mode = "0400";
    };
  };
  services = { 
    hydra = {
      enable = true;
      hydraURL = "https://hydra.gl4dos.com";
      notificationSender = "hydra@gl4dos.com";
      useSubstitutes = true;
      extraConfig = ''
          evaluator_workers = 3
      '';
      cloudflared = {
        enable = true;
        tunnels.hydra = {
          credentialsFile = config.age.secrets.cloudflared-hydra.path;
          default = "http_status:404";
          ingress = {
            "hydra.gl4dos.com" = "http://localhost:3000";
          };
        };
      };
    };
    postgresql.enable = true;
  };

  nix.settings = {
    max-jobs = 16;
    min-free = 50 * 1024 * 1024 * 1024;
    post-build-hook = "${postBuildHook}";
    extra-substituters = [ "http://localhost:8080/fuzzflakes" ];
    extra-trusted-public-keys = [
      "fuzzflakes:M5ytPUF9rvCKpabVrppT9LAKkNr5Y5Z6pw7zA/HKi+0="
    ];
  };
  programs.ssh.extraConfig = ''
    Host github.com
      User git
      IdentityFile ${config.age.secrets.hydra-github-ssh.path}
      StrictHostKeyChecking yes
  '';
  environment.etc."ssh/ssh_known_hosts".text = ''
    github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
    github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
    github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C4G97Tegp3y/9zIWeygbkEo11mk=
  '';
  users.users.cloudflared = {
    isSystemUser = true;
    group = "cloudflared";
  };
  users.groups.cloudflared = {};
}

