# modules/home/hyprland/default.nix

{ inputs, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
    ./waybar.nix
    ./wofi.nix
    ./cursor.nix
    ./hypridle.nix
    ./hyprlock.nix
  ];
}
