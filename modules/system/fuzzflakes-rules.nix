{ ... }:
{
    systemd.services.nix-daemon.serviceConfig.Delegate = "memory pids";
    nix.settings.use-cgroups = true;
}
