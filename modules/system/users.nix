#modules/system/users.nix
{ pkgs, ... }:

{
  users = {
    defaultUserShell = pkgs.fish;
    groups.cloudflared = { };
    users.themos = {
      isNormalUser = true;
      description = "User";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKpLy/pUGGpYkkOZS2CQeMDPkYYZFzxcoC67ELiu9h88"
      ];
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
        "storage"
        "docker"
        "libvirtd"
        "kvm"
      ];
    };
    users.qwerty = {
      isNormalUser = true;
      description = "User";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGVbVr+TWs05TtU9MlO6K3UUFxXpFfBH8a8SeULUHYNU"
      ];
      packages = with pkgs; [
        git
        docker
        docker-compose
        php83
      ];
    };
    users.koukos = {
      isNormalUser = true;
      description = "User";
      openssh.authorizedKeys.keys = [
      ];
      packages = with pkgs; [
        git
        aflplusplus
      ];
    };
  };

  security.sudo.enable = true;
  programs.fish.enable = true;
}
