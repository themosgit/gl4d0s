# modules/system/packages.nix
{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  #packages installed on the system for every user
  environment.systemPackages = with pkgs; [
      (writeShellScriptBin "qemu-system-x86_64-uefi" ''
        qemu-system-x86_64 \
        - bios ${OVMF.fd}/FV/OVMF.fd \
        "$@"
    '')
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
    # syncthing
    firefox
    ghostty
    luajitPackages.luarocks
    #for games
    mangohud
    protonup


    #for alisases to work we
    #put the dependencies in
    #the system packages
    eza #better ls
    dust #better du
    fd #better find
    ripgrep #better grep
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
          ovmf = {
              enable = true;
              packages = [(pkgs.OVMF.override {
                  secureBoot = true;
                  tpmSupport = true;
               }).fd];
          };
       };
    };


  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
  };
  /**
   *  services.syncthing = {
   *    enable = true;
   *    openDefaultPorts = true;
   *    user = "themos";
   *    configDir = "/home/themos/.config/syncthing";
   *    guiAddress = "0.0.0.0:8384";
   *    settings = {
   *        overrideDevices = true;
   *        overrideFolders = true;
   *        devices = {
   *        };
   *    };
   *  };
   *
   *  systemd.services.pascual-notifier = {
   *    wantedBy = [ "multi-user.target" ];
   *    serviceConfig = {
   *      ExecStart = "${pkgs.nodejs}/bin/node /home/qwerty/fetcher/index.js";
   *      WorkingDirectory = "/home/qwerty/fetcher";
   *      Restart = "always";
   *      User = "qwerty";
   *      StandardOutput = "append:/home/qwerty/fetcher/fetcher.log";
   *      StandardError = "append:/home/qwerty/fetcher/fetcher.log";
   *    };
   *  };
   *
   **/

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.libvirt.unix.manage" &&
            subject.isInGroup("libvirtd")) {
                return polkit.Result.YES;
            }
        });
    '';


  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
    ];
    fontconfig.enable = true;
  };

  programs = {
    git.enable = true;
    zoxide.enable = true;
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  programs.gamemode.enable = true;
}
