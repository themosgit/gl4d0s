# modules/home/hyprland/cursor.nix

{ inputs, pkgs, ... }:

{
  home.pointerCursor = {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 32;
    gtk.enable = true;
    x11.enable = true;
  };
}
