{
  description = "Personal Nix config for NixOS, macOS (nix-darwin) and standalone Home Manager";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-unified.url = "github:srid/nixos-unified";

    # System and user management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Shell tooling
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Linux desktop (only used when `me.desktop.enable = true`)
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Deliberately no `inputs.nixpkgs.follows`. Following nixpkgs would make Nix compile
    # noctalia locally, because the binary cache below only has builds against its own nixpkgs.
    noctalia.url = "github:noctalia-dev/noctalia";
  };

  # Pre-built noctalia binaries. Nix only honors this when you pass --accept-flake-config
  # (or are a trusted user). The NixOS config also installs it system-wide after the first switch.
  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  # Everything under configurations/ and modules/ is wired up automatically.
  # See https://nixos-unified.org/guide/autowiring and the README.
  outputs =
    inputs:
    inputs.nixos-unified.lib.mkFlake {
      inherit inputs;
      root = ./.;
    };
}
