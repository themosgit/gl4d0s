# modules/system/default.nix
{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./headless.nix
    ./networking.nix
    ./services.nix
    ./users.nix
    ./hyprland.nix
    ./audio.nix
    ./packages.nix
    ./remap.nix
    ./fuzzflakes-build
    #   ./swap.nix
  ];

  # >>> the switch <<<
  # true  = server: no display server, no audio, no desktop/gaming packages
  # false = workstation: Hyprland, greetd, PipeWire, Steam, GUI apps
  gl4dos.headless.enable = true;

  # Kept in both modes: ROCm needs the amdgpu driver and /run/opengl-driver.
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  # Only meaningful with an X server running.
  services.xserver.videoDrivers = lib.optionals (!config.gl4dos.headless.enable) [ "amdgpu" ];
  boot.initrd.kernelModules = [ "amdgpu" ];

  system.stateVersion = "25.11";
  systemd.services.nix-daemon = {
    serviceConfig = {
      Delegate = true;
    };
  };
  #enable flakes
  nix.settings.experimental-features = "nix-command flakes cgroups recursive-nix";
  nix.settings.use-cgroups = true;

  nix.settings.trusted-users = [
    "root"
    "themos"
  ];
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
