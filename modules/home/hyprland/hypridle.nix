# modules/home/hyprland/hypridle.nix

{ inputs, pkgs, ... }:

{
  services.hypridle = {
    enable = true;
    
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";       # Command to run when locking
        before_sleep_cmd = "loginctl lock-session";    # Command to run before sleep
        after_sleep_cmd = "hyprctl dispatch dpms on";  # Command to run after sleep
        ignore_dbus_inhibit = false;                   # Whether to ignore dbus-sent idle-inhibit requests
      };

      listener = [
        # Dim screen after 2.5 minutes
        {
          timeout = 150;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        
        # Turn off keyboard backlight after 2.5 minutes
        {
          timeout = 150;
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
          on-resume = "brightnessctl -rd rgb:kbd_backlight";
        }
        
        # Lock screen after 5 minutes
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        
        # Turn off screen after 5.5 minutes
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        
        # Suspend system after 30 minutes
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}


