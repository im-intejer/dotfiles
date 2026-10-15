# Entry point for every NixOS machine (host files import this as `self.nixosModules.default`).
# For per-user settings see /modules/home/*.
#
# The modules below do nothing until their switch is turned on in the host file
#   me.desktop.enable  (desktop.nix)  niri + DankMaterialShell + login screen
#   me.gaming.enable   (gaming.nix)   Steam
{ ... }:
{
  imports = [
    ./common
    ./desktop.nix
    ./gaming.nix
  ];

  services.openssh.enable = true;
}
