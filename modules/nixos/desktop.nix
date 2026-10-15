# The graphical session for NixOS, switched on with `me.desktop.enable = true;`
#
#   login screen   greetd with the DankMaterialShell greeter
#   compositor     niri (Wayland)
#   shell          DankMaterialShell, configured per user in /modules/home/desktop.nix
#
# GNOME is intentionally absent. Nothing here pulls in X11 or GDM.
{ config, flake, lib, pkgs, ... }:
let
  inherit (flake) inputs;
  cfg = config.me.desktop;

  # The greeter copies this user's DankMaterialShell theme and wallpaper to the login screen.
  mainUser = lib.head config.myusers;
in
{
  imports = [ inputs.dank-greeter.nixosModules.default ];

  options.me.desktop.enable = lib.mkEnableOption "the niri and DankMaterialShell desktop with a graphical login screen";

  config = lib.mkIf cfg.enable {
    # Compositor. This registers the "niri" session with the login screen and sets up
    # portals (screen sharing, file pickers) and the keyring.
    programs.niri.enable = true;
    services.displayManager.defaultSession = "niri";

    # Login manager. greetd starts the DankMaterialShell greeter inside a tiny niri instance.
    programs.dms-greeter = {
      enable = true;
      compositor.name = "niri";
      configHome = config.users.users.${mainUser}.home;
    };
    # Unlock the keyring with the login password.
    security.pam.services.greetd.enableGnomeKeyring = true;

    # Things DankMaterialShell talks to (battery, power profiles, avatars, location, auth prompts).
    services = {
      upower.enable = true;
      power-profiles-daemon.enable = true;
      accounts-daemon.enable = true;
      geoclue2.enable = true;
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

    # Fonts used by DankMaterialShell.
    fonts.packages = with pkgs; [
      inter
      fira-code
      material-symbols
    ];

    # Ask Electron and Chromium apps to use Wayland.
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # Give every user's Home Manager config the same switch, so /modules/home/desktop.nix
    # writes the matching per-user settings.
    home-manager.sharedModules = [{ me.desktop.enable = lib.mkDefault true; }];
  };
}
