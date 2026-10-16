# The graphical session for NixOS, switched on with `me.desktop.enable = true;`
#
#   login screen   greetd with the Noctalia greeter
#   compositor     niri (Wayland)
#   shell          Noctalia, configured per user in /modules/home/desktop.nix
#
# GNOME is intentionally absent. Nothing here pulls in X11 or GDM.
{ config, lib, pkgs, ... }:
let
  cfg = config.me.desktop;
in
{
  options.me.desktop.enable = lib.mkEnableOption "the niri and Noctalia desktop with a graphical login screen";

  config = lib.mkIf cfg.enable {
    # Compositor. This registers the "niri" session with the login screen and sets up
    # portals (screen sharing, file pickers) and the keyring.
    programs.niri.enable = true;
    services.displayManager.defaultSession = "niri";

    # Login manager. This turns on greetd and starts the Noctalia greeter, which lists the
    # niri session. Use `noctalia msg greeter-sync` to copy your shell theme to it.
    services.displayManager.noctalia-greeter.enable = true;
    # Unlock the keyring with the login password.
    security.pam.services.greetd.enableGnomeKeyring = true;

    # Things Noctalia talks to (Wi-Fi, Bluetooth, battery and power profiles).
    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
    services = {
      upower.enable = true;
      power-profiles-daemon.enable = true;
      libinput.enable = true;
    };
    security.polkit.enable = true;

    # Graphics and sound.
    hardware.graphics.enable = lib.mkDefault true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    # Noctalia draws its own icons, but text needs real fonts.
    fonts = {
      enableDefaultPackages = true;
      packages = [ pkgs.inter ];
    };

    # Prebuilt Noctalia binaries. See nixConfig in flake.nix for the first build.
    nix.settings = {
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };

    # Ask Electron and Chromium apps to use Wayland.
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # Give every user's Home Manager config the same switch, so /modules/home/desktop.nix
    # writes the matching per-user settings.
    home-manager.sharedModules = [{ me.desktop.enable = lib.mkDefault true; }];
  };
}
