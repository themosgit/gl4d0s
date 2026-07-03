# modules/system/packages.nix
{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  #packages installed on the system for every user
  environment.systemPackages = with pkgs; [
    llvmPackages.libcxxClang
    virt-manager
    gnumake
    neovim
    wget
    htop
    curl
    nmap
    unzip
    tree
    git
    wl-clipboard
    nettools
    traceroute
    file
    # syncthing
    firefox
    ghostty
    luajitPackages.luarocks
    spotify
    #for games
    mangohud
    protonup-ng
    protontricks
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
  ];
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
    packages = with pkgs; [
      corefonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
    ];
    fontconfig.enable = true;
  };

  programs = {
    git.enable = true;
    zoxide.enable = true;
    bat.enable = true;
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  programs.gamemode.enable = true;
}
