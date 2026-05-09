{ pkgs, config, ... }:

{

  systemd.services.hc-tracker = {
      wantedBy = [ "multi-user.target" ];
      description = "Hackcenter Tracker";
      serviceConfig = {
          ExecStart = "${
              pkgs.python313.withPackages (
                ps: with ps; [
                  discordpy
                  python-dotenv
                  requests
                  tzdata
                ]
              )
          }/bin/python -u /home/qwerty/tracker/bot.py";
          WorkingDirectory = "/home/qwerty/tracker";
          Restart = "always";
          RestartSec = "10sec";
          User = "qwerty";
          StandardOutput = "append:/home/qwerty/tracker/tracker.log";
          StandardError = "append:/home/qwerty/tracker/tracker.log";
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
}
