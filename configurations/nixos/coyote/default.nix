# Apply this config with `just run` or `sudo nixos-rebuild switch --flake .#coyote`

# Coyote is an HP EliteDesk 800 G4 running NixOS.
 
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
  me.desktop.enable = false; # niri + Noctalia + graphical login screen
  me.gaming.enable = false; # Steam
}
