#modules/system/users.nix
{ pkgs, ... }:

{
  users = {
    defaultUserShell = pkgs.fish;
    groups.cloudflared = {};
    users.themos = {
      isNormalUser = true;
      description = "User";
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
        };
  };

  security.sudo.enable = true;
  programs.fish.enable = true;
}
