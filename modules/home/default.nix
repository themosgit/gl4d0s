# modules/home/default.nix

{
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}:

{
  # osConfig is the NixOS config, handed to us by home-manager's NixOS module,
  # so the desktop half of the home config follows the same switch.
  imports = [
    ./shell-conf
    ./home-packages.nix
    ./git.nix
  ]
  ++ lib.optionals (!osConfig.gl4dos.headless.enable) [ ./hyprland ];

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
