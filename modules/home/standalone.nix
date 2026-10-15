# Settings that only apply when Home Manager runs on its own, as a package manager on top of
# another OS (Ubuntu, Fedora, WSL, macOS ...). When it is part of NixOS or nix-darwin the
# system takes care of these things.
{ lib, osConfig ? null, ... }:
{
  # Provides the `home-manager` command.
  programs.home-manager.enable = lib.mkDefault (osConfig == null);
}
