# modules/system/packages.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  desktop = !config.gl4dos.headless.enable;
in

{
  nixpkgs.config.allowUnfree = true;
  #packages installed on the system for every user
  environment.systemPackages =
    (with pkgs; [
      llvmPackages.libcxxClang
      gnumake
      neovim
      wget
      htop
      curl
      nmap
      unzip
      tree
      git
      nettools
      traceroute
      file
      # syncthing
      luajitPackages.luarocks
      python313
      rocmPackages.rocminfo
      rocmPackages.rocm-smi
      radeontop
      openssl
      sqlite

      aflplusplus
      cachix
      cloudflared

      #for alisases to work we
      #put the dependencies in
      #the system packages
      eza # better ls
      dust # better du
      fd # better find
      git-lfs
      ripgrep # better grep
      opencode
    ])
    ++ lib.optionals desktop (
      with pkgs;
      [
        virt-manager # GUI for libvirtd; use virsh when headless
        wl-clipboard
        firefox
        ghostty
        spotify
        #for games
        mangohud
        protonup-ng
        protontricks
      ]
    );

  programs.nix-ld.enable = true;
  security.polkit.enable = true;

  #enable optimizations
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  fonts = {
    # Nothing renders text here when headless; the ssh client supplies the font.
    packages = lib.optionals desktop (
      with pkgs;
      [
        corefonts
        nerd-fonts.jetbrains-mono
        nerd-fonts.symbols-only
      ]
    );
    fontconfig.enable = true;
  };

  programs = {
    git.enable = true;
    zoxide.enable = true;
    bat.enable = true;
  };

  programs.steam.enable = desktop;
  programs.steam.gamescopeSession.enable = desktop;

  programs.gamemode.enable = desktop;
}
