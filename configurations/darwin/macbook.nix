# A Mac managed by nix-darwin. Apply it with `just run` or `sudo darwin-rebuild switch --flake .#macbook`
#
# First time setup
#   1. Install Nix, then run `nix run nix-darwin -- switch --flake .#macbook`
#   2. The file name must match your Mac's host name, see `scutil --get LocalHostName`.
#      Rename this file if they differ.
#
# The desktop (niri, DankMaterialShell) and Steam are Linux only, so there is nothing
# to switch on here. Your shell, git and editor setup still comes from /modules/home/*.
{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [ self.darwinModules.default ];

  nixpkgs.hostPlatform = "aarch64-darwin"; # Use "x86_64-darwin" on an Intel Mac

  # Must match your macOS account name and have a file at configurations/home/<name>.nix
  myusers = [ "upwrd" ];

  # If you installed Nix with the Determinate installer, let it manage Nix instead.
  # nix.enable = false;

  system.stateVersion = 6;
}
