{ pkgs, ... }:

{
  users.users.yannis = {
    isNormalUser = true;
    description = "Yannis";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager.users.yannis = import ./home.nix;
}