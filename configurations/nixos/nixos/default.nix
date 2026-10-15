# The NixOS machine called "nixos". Apply it with `just run` or `sudo nixos-rebuild switch --flake .#nixos`
#
# Reusable settings live in /modules/nixos/. Only what is specific to this machine goes here.
{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.default
    ./configuration.nix
  ];

  # Users on this machine. Each one needs configurations/home/<name>.nix
  myusers = [ "upwrd" ];

  # Feature switches
  me.desktop.enable = true; # niri + DankMaterialShell + graphical login screen
  me.gaming.enable = true; # Steam
}
