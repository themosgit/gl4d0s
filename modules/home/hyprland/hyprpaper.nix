# modules/home/hyprland/hyprpaper.nix

{ inputs, pkgs, ... }:

{
  services.hyprpaper = {
      enable = true;
      settings = {
        ipc = true;
	splash = false;
	splash_offset = 2.0;

        preload = [
	  "/home/themos/Wallpapers/nix-wallpaper-nineish-dark-gray.jpg"
	];
	wallpaper = [
	  ",/home/themos/Wallpapers/nix-wallpaper-nineish-dark-gray.jpg"
	];
      };
    };
}
