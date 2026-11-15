# Steam and the usual helpers, switched on with `me.gaming.enable = true;`
#
# Steam needs an X11 server, which niri provides through xwayland-satellite.
# That is configured in /modules/home/desktop.nix, so pair this with me.desktop.enable.
{ config, lib, pkgs, ... }:
let
  cfg = config.me.gaming;
in
{
  options.me.gaming.enable = lib.mkEnableOption "Steam and game helpers";

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = pkgs.stdenv.hostPlatform.isx86_64;
      message = "me.gaming.enable needs an x86_64 machine because Steam is x86 only.";
    }];

    # Steam is unfree. Allow just the packages it needs.
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
      ];

    # This also turns on 32-bit graphics, 32-bit audio and the udev rules for controllers.
    programs.steam = {
      enable = true;
      # remotePlay.openFirewall = true;             # Steam Remote Play
      # localNetworkGameTransfers.openFirewall = true;  # Copy games between PCs on your LAN
    };

    # In a game's Steam launch options use `gamemoderun %command%` or `gamescope -- %command%`.
    programs.gamemode.enable = true;
    programs.gamescope.enable = true;
  };
}
