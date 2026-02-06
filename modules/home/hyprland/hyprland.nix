# modules/home/hyprland/hyprland.nix

{ inputs, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    settings = {

    monitor = [
      ",preferred,auto,1"
    ];

    input = {
      kb_layout = "us";
      follow_mouse = 1;
      sensitivity = 0;
    };

    general = {
      gaps_in = 1;
      gaps_out = 1;
      border_size = 0;
      layout = "dwindle";
    };
    animations = {
      enabled = true;
      animation = [
      	"windows, 1, 3, default, popin 80%"
	    "windowsOut, 1, 3, default, popin 80%"
	    "border, 1, 3, default"
	    "borderangle, 1, 3, default"
	    "fade, 1, 3, default"
	    "workspaces, 1, 3, default"
      ];
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    windowrule = [
      "float on, match:class ^(vicinae)$"
      "match:class ^(vicinae)$, center on"
      "match:class ^(thunar)$, float on"
      "match:class ^(thunar)$, size 800 600"
      "match:class ^(thunar)$, center on"
    ];

    decoration = {
        blur = {
            enabled = true;
            size = 5;
            passes = 3;
            new_optimizations = true;
            ignore_opacity = true;
        };
    };

    "$mod" = "SUPER";
    bind = [

      "$mod, Q, killactive,"
      "$mod, SPACE, exec, vicinae open"
      "$mod, ENTER, exec, ghostty"
      "$mod, B, exec, firefox"
      ", PRINT, exec, hyprshot -m output"
      "$mod, PRINT, exec, hyprshot -m region"
      "$mod, V, togglefloating,"
      "$mod, F, fullscreen,"

      "$mod, L, movefocus, r"
      "$mod, H, movefocus, l"
      "$mod, K, movefocus, u"
      "$mod, J, movefocus, d"

      "$mod, left, resizeactive, -50 0"
      "$mod, down, resizeactive, 0 50"
      "$mod, up, resizeactive, 0 -50"
      "$mod, right, resizeactive, 50 0"


      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 10, workspace, 10"

      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod SHIFT, 10, movetoworkspace, 10"
    ];
  };
  };
}
