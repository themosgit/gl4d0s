{ pkgs, config, ... }:

{
 systemd.services.htb-discord-bot = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "HackTheBox Discord Bot";
      serviceConfig = {
        ExecStart = "${pkgs.python313.withPackages (ps: with ps; [ discordpy python-dotenv requests tzdata ])}/bin/python -u /home/qwerty/HTB-Progress-Tracker/bot.py";
        WorkingDirectory = "/home/qwerty/HTB-Progress-Tracker";
        Restart = "always";
        RestartSec = "10s";
        User = "qwerty";
        StandardOutput = "append:/home/qwerty/HTB-Progress-Tracker/update.log";
        StandardError = "append:/home/qwerty/HTB-Progress-Tracker/update.log";
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
