# Like GNU `make`, but `just` rustier.
# https://just.systems/
# run `just` from this directory to see available commands

# Default command when 'just' is run without arguments
default:
  @just --list

# Update nix flake
[group('Main')]
update:
  nix flake update

# Apply the configuration of this machine (NixOS or macOS)
[group('Main')]
run:
  nix run

# Apply only the Home Manager config, for use as a package manager on any OS
[group('Main')]
home:
  nix run .#activate -- $USER@localhost

# Lint nix files
[group('dev')]
lint:
  nix fmt

# Check nix flake
[group('dev')]
check:
  nix flake check

# Manually enter dev shell
[group('dev')]
dev:
  nix develop

# Build here, then test-activate on a remote NixOS host. Does not change the boot default,
# so a power cycle returns the host to its last good generation.
[group('Main')]
deploy-test host user="upwrd":
  nixos-rebuild test --flake .#{{host}} --target-host {{user}}@{{host}} --sudo --ask-elevate-password

# Build here and switch a remote NixOS host to the new configuration permanently
[group('Main')]
deploy host user="upwrd":
  nixos-rebuild switch --flake .#{{host}} --target-host {{user}}@{{host}} --sudo --ask-elevate-password

