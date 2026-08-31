# modules/home/shell-conf/default.nix

{
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}:

{
  imports = [
    ./config-files.nix
    ./fish.nix
    ./starship.nix
    ./starship-symbols.nix
  ]
  ++ lib.optionals (!osConfig.gl4dos.headless.enable) [ ./ghostty.nix ];
}
