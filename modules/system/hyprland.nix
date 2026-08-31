#modules/system/hyprland.nix
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf (!config.gl4dos.headless.enable) {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  #wayland services
  security.polkit = {
    enable = true;
    extraConfig = ''
      	polkit.addRule(function(action, subject) {
      	  if ( subjext.isInGroup("users") && (
      	    action.id == "org.freedesktop.login1.reboot" ||
      	    action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
      	    action.id == "org.freedesktop.login1.power-off" ||
      	    action.id == "org.freedesktop.login1.power-off-multiple sessions"
      	  ))
      	  { return polkit.Result.YES; }
      	})
    '';
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

}
