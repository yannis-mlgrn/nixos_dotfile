{ pkgs, ... }:

{
  users.users.yannis = {
    isNormalUser = true;
    description = "Yannis";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "input"];
    group = "yannis";
    shell = pkgs.zsh;
  };

  users.groups.yannis = {};

  home-manager.users.yannis = import ./home.nix;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    zsh-autoenv.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
       enable = true;
       theme = "robbyrussell";
       plugins = [
         "git"
         "npm"
         "history"
         "node"
         "rust"
         "deno"
         "z"
       ];
    };
  };
}
