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
