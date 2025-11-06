# modules/home/shell-conf/default.nix

{ inputs, pkgs, ... }:

{
  imports = [
    ./config-files.nix
    ./fish.nix
    ./ghostty.nix
    ./starship.nix
    ./starship-symbols.nix
  ];
}
