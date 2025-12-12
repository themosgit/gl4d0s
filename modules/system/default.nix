# modules/system/default.nix
{ inputs, pkgs, ... }:

{
  imports = [
    ./networking.nix
    ./users.nix
    ./hyprland.nix
    ./audio.nix
    ./packages.nix
    ./remap.nix
  ];

  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "amdgpu" ];

  system.stateVersion = "25.05";

  #enable flakes
  nix.settings.experimental-features = "nix-command flakes";

  #bootloader
  boot.loader.systemd-boot.enable = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  #timezone
  time.timeZone = "Europe/Athens";

  #auto updates
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";

  #auto cleanup
  nix.settings.auto-optimise-store = true;
}
