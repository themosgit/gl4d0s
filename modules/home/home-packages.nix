# modules/home/packages.nix

{ inputs, pkgs, ... }:

{
  #user environment packages
  home.packages = with pkgs; [
    hyperfine # benchmark tool
    mosh # ssh wrapper
    wireplumber
    nixfmt-rfc-style
    gh
    fastfetch
    btop
    nmap
    neovim
    firefox
    ghostty
    thunderbird
    vesktop
    keepassxc
    shotman
    brightnessctl
    python314
    zathura
    hyprshot
    tmux
    socat
    netcat-gnu
    presenterm
    mistral-vibe
    claude-code
  ];

  programs.bat.enable = true;
  programs.bat.config.style = "plain";

  programs.fd.enable = true;

  programs.eza.enable = true;
  programs.eza.git = true;
  programs.eza.icons = "auto";

  home.sessionVariables.EZA_COLORS = "xx=0";
  home.sessionVariables.EZA_ICON_SPACING = 2;

}
