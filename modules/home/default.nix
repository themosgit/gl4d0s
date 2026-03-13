# modules/home/default.nix

{ inputs, pkgs, ... }:

{

  imports = [
    ./hyprland
    ./shell-conf
    ./home-packages.nix
    ./git.nix
  ];

  home = {
    username = "themos";
    homeDirectory = "/home/themos";
    stateVersion = "25.05";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    addKeysToAgent = "yes";
    extraConfig = ''
      	IdentityFIle ~/.ssh/id_ed25519
    '';
  };

  programs.home-manager.enable = true;
}
