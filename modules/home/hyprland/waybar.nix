# modules/home/hyprland/waybar.nix

{ inputs, pkgs, ... }:

{
  home.file.".config/waybar/platform_profile.sh" = {
    text = ''
      #!/bin/sh
      echo "{\"alt\": \"$(cat /sys/firmware/acpi/pm_profile)\"}"
    '';
    executable = true;
  };

  programs.waybar = {
    enable = false;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 24;
        spacing = 5;

        modules-left = [
          "hyprland/workspaces"
          "custom/platform-profile"
          "temperature"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "wireplumber"
          "hyprland/language"
          "idle_inhibitor"
          "network"
          "tray"
        ];

        "hyprland/workspaces" = {
          format = "<span size='larger'>{icon}</span>";
          on-click = "activate";
          format-icons = {
            active = "";
            default = "";
          };
          icon-size = 10;
          sort-by-number = true;
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
        };

        clock = {
          format = "{:%d.%m.%Y | %H:%M}";
        };

        wireplumber = {
          format = "  {volume}%";
          max-volume = 100;
          scroll-step = 5;
        };

        memory = {
          interval = 30;
          format = "  {used:0.1f}G";
        };

        temperature = {
          format = "{temperatureC}°C";
        };

        network = {
          format = "";
          format-ethernet = "󰈀";
          format-wifi = "{icon}";
          format-disconnected = "󰈂";
          tooltip-format-ethernet = "{ifname}";
          tooltip-format-disconnected = "Disconnected";
        };

        "hyprland/language" = {
          format = "{short}";
        };

        tray = {
          icon-size = 16;
          spacing = 16;
        };

        "custom/platform-profile" = {
          format = "{icon} ";
          exec = "~/.config/waybar/platform_profile.sh";
          return-type = "json";
          restart-interval = 1;
          format-icons = {
            default = "󰈐";
          };
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "\udb80\udd76";
            deactivated = "\udb83\udfaa";
          };
        };
      };
    };

    style = ''
      @define-color foreground #eeeeee;
      @define-color foreground-inactive #aaaaaa;
      @define-color background #000000;

      * {
          font-family: JetBrainsMono Nerd Font;
          font-size: 10px;
          padding: 0;
          margin: 0;
      }

      #waybar {
          color: @foreground;
          background-color: @background;
      }

      #workspaces button {
          color: @foreground;
          padding-left: 0.7em;
      }

      #workspaces button.empty {
          color: @foreground-inactive;
      }

      #memory,
      #custom-platform-profile {
          padding-left: 1em
      }

      #wireplumber,
      #idle_inhibitor,
      #language,
      #network,
      #tray {
          padding-right: 1em 
      }
    '';
  };
}
