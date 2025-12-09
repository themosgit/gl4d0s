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
    wireshark
    #for games
    mangohud
    protonup-ng
    protontricks
    python313


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

  programs.wireshark.enable = true;
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

    systemd.services.aoc-solver = {
      description = "Advent of Code Auto Solver";
      serviceConfig = {
        Type = "oneshot"; 
        User = "qwerty";
        WorkingDirectory = "/home/qwerty/aoc_solver"; 
        ExecStart = "${pkgs.python313.withPackages (ps: with ps; [ 
          requests 
          beautifulsoup4 
          google-generativeai 
          python-dotenv 
        ])}/bin/python -u /home/qwerty/aoc_solver/bot.py";
        
        StandardOutput = "append:/home/qwerty/aoc_solver/solver.log";
        StandardError = "append:/home/qwerty/aoc_solver/solver.log";
      };
    };


    systemd.timers.aoc-solver = {
      wantedBy = [ "timers.target" ];
      partOf = [ "aoc-solver.service" ];
      timerConfig = {
       
        OnCalendar = "*-*-* 07:00:00"; 
        

        Persistent = true; 
        
        Unit = "aoc-solver.service";
      };
    };

 systemd.services.htb-discord-bot = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "HackTheBox Discord Bot";
      serviceConfig = {
        ExecStart = "${pkgs.python313.withPackages (ps: with ps; [ discordpy python-dotenv requests tzdata ])}/bin/python -u /home/qwerty/htb_bot/bot.py";
        WorkingDirectory = "/home/qwerty/htb_bot";
        Restart = "always";
        RestartSec = "10s";
        User = "qwerty";
        StandardOutput = "append:/home/qwerty/htb_bot/update.log";
        StandardError = "append:/home/qwerty/htb_bot/update.log";
      };
    };
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
      corefonts
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
