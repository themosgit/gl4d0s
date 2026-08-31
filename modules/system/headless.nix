# modules/system/headless.nix
#
# The single switch that decides whether this box is a workstation or a server.
# Everything display-, audio- or input-shaped keys off it. The amdgpu kernel
# driver and hardware.graphics stay on either way, so ROCm compute keeps working
# with no monitor attached.
{ config, lib, ... }:

let
  cfg = config.gl4dos.headless;
in

{
  options.gl4dos.headless.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Run without a display server: no Hyprland, no greeter, no PipeWire, no
      desktop or gaming packages, and boot behaviour that never waits on a
      console. GPU compute (ROCm) is unaffected.
    '';
  };

  config = lib.mkIf cfg.enable {
    # Nobody is at the keyboard to answer a prompt, so never block on one.
    systemd.enableEmergencyMode = false;
    boot.kernelParams = [
      "panic=30"
      "boot.panic_on_fail"
    ];
    boot.loader.timeout = lib.mkDefault 1;

    # No idle suspend, no accidental power-button shutdown.
    services.logind.settings.Login = {
      HandlePowerKey = "ignore";
      HandleSuspendKey = "ignore";
      HandleLidSwitch = "ignore";
      IdleAction = "ignore";
    };

    # NOTE: deliberately NOT disabling getty. With greetd gone, NixOS wires
    # getty.target -> autovt@tty1.service, which is the local rescue console for
    # when sshd or tailscale break. nixpkgs' own profiles/headless.nix kills it;
    # we keep it, and VTs 2-6 cost nothing until someone switches to them.

    # Docs nothing on this machine can render.
    documentation.doc.enable = lib.mkDefault false;
    documentation.nixos.enable = lib.mkDefault false;

    xdg.icons.enable = lib.mkDefault false;
    xdg.sounds.enable = lib.mkDefault false;
    xdg.autostart.enable = lib.mkDefault false;
  };
}
