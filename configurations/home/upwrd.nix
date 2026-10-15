# Home Manager config for the user "upwrd". It is used in two ways
#   NixOS or macOS   pulled in through `myusers` in the host file
#   standalone       `just home`, or `nix run .#activate -- upwrd@localhost`
#
# The settings themselves live in /modules/home/*
{ flake, pkgs, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.default
  ];

  # Options defined by /modules/home/me.nix and used all around /modules/home/*
  me = {
    username = "upwrd";
    fullname = "Luke Davis";
    email = "lukendavis7@gmail.com";
    shell = pkgs.zsh;

    # Standalone Linux only. On NixOS the host file decides, on macOS it does not apply.
    # desktop.enable = true;
  };

  home.stateVersion = "20.09";
}
