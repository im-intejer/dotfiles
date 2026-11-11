# Declares which users a machine has, for both NixOS and nix-darwin.
#
# Each name needs a Home Manager file at configurations/home/<name>.nix.
# Hosts list their users explicitly, for example `myusers = [ "upwrd" ];`
{ flake, pkgs, lib, config, ... }:
let
  inherit (flake.inputs) self;
  mapListToAttrs = m: f:
    lib.listToAttrs (map (name: { inherit name; value = f name; }) m);
in
{
  options.myusers = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    example = [ "upwrd" ];
    description = "Usernames of this machine. Each needs configurations/home/<name>.nix";
  };

  config = {
    assertions = [{
      assertion = config.myusers != [ ];
      message = "Set `myusers` in your host file, otherwise nobody can log in.";
    }];

    # For home-manager to work.
    # https://github.com/nix-community/home-manager/issues/4026#issuecomment-1565487545
    users.users = mapListToAttrs config.myusers (name:
      lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
        home = "/Users/${name}";
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        isNormalUser = true;
      }
    );

    # Enable home-manager for our users.
    home-manager.users = mapListToAttrs config.myusers (name: {
      imports = [ (self + /configurations/home/${name}.nix) ];
    });

    # All users can add Nix caches.
    nix.settings.trusted-users = [ "root" ] ++ config.myusers;
  };
}
