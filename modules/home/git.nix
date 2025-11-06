# modules/home/git.nix
{ ... }:

{
  programs.git = {
    enable = true;
    userName = "themos";
    userEmail = "themos360@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      pull.rebase = true;
      credential.helper = "!gh auth git-credential";
    };
  };
}
