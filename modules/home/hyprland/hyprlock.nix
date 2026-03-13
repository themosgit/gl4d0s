# modules/home/hyprland/hyprlock.nix

{ inputs, pkgs, ... }:

{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        disable_loading_bar = true;
        grace = 0; # Seconds before requiring password
        hide_cursor = true;
        no_fade_in = false;
      };

      # Background
      background = [
        {
          path = "/home/themos/Wallpapers/nix-wallpaper-nineish-dark-gray.jpg"; # Use screenshot as background, or specify path to image
        }
      ];

      # Input field (password box)
      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = true;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 2;
          placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
          shadow_passes = 2;
        }
      ];

      # Clock
      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "<b><big> $(date +"%H:%M") </big></b>"'';
          color = "rgb(202, 211, 245)";
          font_size = 42;
          font_family = "JetBrains Mono Nerd Font 10";
          position = "0, 8";
          halign = "right";
          valign = "bottom";
          shadow_passes = 5;
          shadow_size = 10;
        }
      ];

    };
  };
}
