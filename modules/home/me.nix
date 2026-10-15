# The personal settings of one user. Fill them in at configurations/home/<user>.nix
{ config, lib, ... }:
{
  options.me = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "Your username as shown by `id -un`";
    };
    fullname = lib.mkOption {
      type = lib.types.str;
      description = "Your full name for use in Git config";
    };
    email = lib.mkOption {
      type = lib.types.str;
      description = "Your email for use in Git config";
    };
    shell = lib.mkOption {
      type = lib.types.package;
      description = "The default shell for this user";
    };
    desktop.enable = lib.mkEnableOption ''
      the niri and DankMaterialShell desktop for this user (Linux only).
      On NixOS this is switched on for you by `me.desktop.enable` in the host file
    '';
  };

  config.home.username = config.me.username;
}
