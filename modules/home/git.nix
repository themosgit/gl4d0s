# modules/home/git.nix
{ ... }:

{
	programs.git = {
		enable = true;
		settings = {
			user.name = "themosgit";
			user.email = "themos360@gmail.com";
			init.defaultBranch = "main";
			push.autoSetupRemote = true;
			url = {
			  "git@github.com:" = {
			    insteadOf = "https://github.com/";
			  };
			};
		};
		signing = {
			key = "~/.ssh/id_ed25519.pub";
			signByDefault = true;
		};
		extraConfig.gpg.format = "ssh";
	};
	services.ssh-agent.enable = true;
}
