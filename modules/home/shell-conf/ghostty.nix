{ config, lib, ... }:

let
  inherit (lib.generators) toKeyValue mkKeyValueDefault;

  mkThemeConfig = toKeyValue {
    mkKeyValue = mkKeyValueDefault { } " = ";
    listsAsDuplicateKeys = true;
  };
in

{
  xdg.configFile."ghostty/config".text = toKeyValue { mkKeyValue = mkKeyValueDefault { } " = "; } {
    font-family = "JetBrains Mono";
    font-size = 13;
    font-thicken = false;

    cursor-invert-fg-bg = true;
    cursor-style = "bar";

    background-opacity = 0.90;

    shell-integration = "fish";

    theme = "Paul Millr";
    # background-blur-radius = 20;

    auto-update = "download";
  };
}
