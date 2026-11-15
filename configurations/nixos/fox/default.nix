# Apply this config with `just run` or `sudo nixos-rebuild switch --flake .#fox`

# Fox is a 2017 Macbook Air running NixOS.
# CPU: Intel i5-5350U @ 1.7Ghz
# 8 GB RAM | 512 GB SSD (256 GB dedicated to NixOS)
 
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
  me.desktop.enable = true; # niri + Noctalia + graphical login screen
  me.gaming.enable = true; # Steam
}
