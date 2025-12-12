# modules/home/git.nix
{ ... }:

{
  programs.git = {
    enable = true;
    user.name = "themos";
    user.email = "themos360@gmail.com";
    init.defaultBranch = "main";
    core.editor = "nvim";
    pull.rebase = true;
    credential.helper = "!gh auth git-credential";
  };
}
