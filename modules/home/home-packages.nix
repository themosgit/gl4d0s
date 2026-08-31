# modules/home/packages.nix

{
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  desktop = !osConfig.gl4dos.headless.enable;
in

{
  #user environment packages
  home.packages =
    (with pkgs; [
      hyperfine # benchmark tool
      mosh # ssh wrapper
      nixfmt-rfc-style
      gh
      fastfetch
      btop
      nmap
      neovim
      python314
      tmux
      socat
      netcat-gnu
      presenterm
      claude-code
      pi-coding-agent
    ])
    ++ lib.optionals desktop (
      with pkgs;
      [
        wireplumber
        firefox
        ghostty
        thunderbird
        vesktop
        keepassxc
        shotman
        brightnessctl
        zathura
        hyprshot
      ]
    );

  programs.bat.enable = true;
  programs.bat.config.style = "plain";

  programs.fd.enable = true;

  programs.eza.enable = true;
  programs.eza.git = true;
  programs.eza.icons = "auto";

  home.sessionVariables.EZA_COLORS = "xx=0";
  home.sessionVariables.EZA_ICON_SPACING = 2;

}
