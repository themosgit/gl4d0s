# modules/home/hyprland/wofi.nix

{ inputs, pkgs, ... }:

{
  # Wofi configuration is now much simpler as the startup behavior
  # is controlled by the `--lines 1` command-line flag.
  programs.wofi = {
    enable = true;

    style = ''
      /* A simple, clean theme for Wofi */
      #window {
        background-color: rgba(0, 0, 0, 0.9);
        border: 1px solid #2C363C;
        border-radius: 10px;
        font-family: "jetbrains-mono";
        font-size: 16px;
      }

      #input {
        color: #F0EDEC;
        background-color: transparent;
        border: none;
        border-bottom: 1px solid #F0EDEC;
        padding: 5px;
        margin: 5px;
      }

      #entry {
        color: #F0EDEC;
        padding: 8px;
        border-radius: 5px;
      }

      #entry:selected {
        background-color: rgba(240, 237, 236, 0.1);
      }
    '';

    settings = {
      prompt = "Run:";
      allow_images = true;
      insensitive = true;
      location = "center";
      normal_window = true;
    };
  };
}