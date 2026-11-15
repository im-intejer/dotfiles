# Settings shared by NixOS and macOS (nix-darwin) machines.
{ ... }:
{
  imports = [
    ./myusers.nix
  ];

  # nixos-unified sets this as a plain string, which current nixpkgs rejects.
  # A list at normal priority overrides its default.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
