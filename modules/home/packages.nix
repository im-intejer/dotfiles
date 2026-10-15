# Packages every user gets on every machine, with or without a desktop.
# GUI apps belong in desktop.nix instead, so macOS and servers stay lean.
# Search for packages at https://search.nixos.org/packages
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Nix tooling
    omnix
    cachix
    nil # Nix language server
    nix-info
    nixpkgs-fmt

    # Unix tools
    ripgrep # Better `grep`
    gnumake
    less # Needed for the `man home-configuration.nix` pager on Ubuntu
    gh

    # Editor
    helix
  ];

  # Programs with a Home Manager module can be set up under `programs.*`.
  programs = {
    bat.enable = true; # Better `cat`
    fzf.enable = true; # Press ctrl+r to fuzzy search your shell history
    btop.enable = true; # https://github.com/aristocratos/btop
  };
}
