# Entry point for every macOS machine managed by nix-darwin
# (host files import this as `self.darwinModules.default`).
# For per-user settings see /modules/home/*.
{ ... }:
{
  imports = [
    # Defines `myusers`. It is imported by path because flake outputs under nixosModules
    # are tagged as NixOS modules, which nix-darwin refuses.
    ../nixos/common
  ];

  # Lets /etc/zshrc load the Nix environment.
  programs.zsh.enable = true;
}
