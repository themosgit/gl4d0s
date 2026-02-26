# modules/system/default.nix
{ inputs, pkgs, ... }:

{
  imports = [
    ./networking.nix
    ./services.nix
    ./users.nix
    ./hyprland.nix
    ./audio.nix
    ./packages.nix
    ./remap.nix
    ./fuzzflakes-rules.nix
    ./attic.nix
  ];

  hardware.graphics = {
  	enable = true;
	extraPackages = with pkgs; [
      	rocmPackages.clr.icd
    ];
  };

  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.initrd.kernelModules = [ "amdgpu" ];

  system.stateVersion = "25.11";

  #enable flakes
  nix.settings.experimental-features = "nix-command flakes cgroups";

  nix.settings.trusted-users = [ "root" "themos" ];
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
