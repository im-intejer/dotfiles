# The per-user side of the desktop, niri (compositor) plus Noctalia (bar, launcher,
# notifications, lock screen). It is switched on by `me.desktop.enable`.
#
# Two situations are handled.
#   NixOS            /modules/nixos/desktop.nix installs niri and the login screen, so this
#                    file only writes the user settings.
#   other Linux      standalone Home Manager. This file also installs niri, but you must still add a
#                    "niri" session to your login manager and have working GPU drivers.
#                    The README has the details.
{ config, flake, lib, pkgs, osConfig ? null, ... }:
let
  inherit (flake) inputs;
  cfg = config.me.desktop;

  # `osConfig` only exists when Home Manager is part of a NixOS or nix-darwin system.
  onSystem = osConfig != null;

  terminal = lib.getExe config.programs.kitty.package;

  # Runs a Noctalia IPC command, for example `noctalia "panel-toggle launcher"`.
  # The full path means keys keep working even if the user profile is not on niri's PATH.
  noctalia = cmd: { spawn-sh = "${lib.getExe config.programs.noctalia.package} msg ${cmd}"; };

  # Mod+1..9 jumps to a workspace, Mod+Shift+1..9 sends the current column there.
  workspaceBinds = lib.listToAttrs (lib.concatMap
    (n: [
      { name = "Mod+${toString n}"; value.action.focus-workspace = n; }
      { name = "Mod+Shift+${toString n}"; value.action.move-column-to-workspace = n; }
    ])
    (lib.range 1 9));
in
{
  # These only declare options. Nothing happens until cfg.enable is true.
  imports = [
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default
  ];

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      assertions = [{
        assertion = pkgs.stdenv.hostPlatform.isLinux;
        message = "me.desktop.enable needs Linux. niri and Noctalia do not run on macOS.";
      }];
    }

    # Everything below is Linux only, so macOS shows the assertion above instead of a build error.
    (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      # Compositor
      programs.niri = {
        # On NixOS the system already installs niri and the login session.
        enable = lib.mkDefault (!onSystem);
        # Use the niri from nixpkgs, which keeps the system and user side in sync.
        package = lib.mkDefault (if onSystem then osConfig.programs.niri.package else pkgs.niri);

        settings = {
          prefer-no-csd = true;
          hotkey-overlay.skip-at-startup = true;

          input = {
            keyboard.xkb.layout = "us";
            touchpad = {
              tap = true;
              tap-button-map = "left-right-middle";
              click-method = "button-areas";
              natural-scroll = true;
            };
          };

          layout = {
            gaps = 12;
            default-column-width.proportion = 0.5;
            preset-column-widths = [
              { proportion = 1.0 / 3.0; }
              { proportion = 1.0 / 2.0; }
              { proportion = 2.0 / 3.0; }
            ];
          };

          # Noctalia's settings window opens as a floating window, as its docs recommend.
          window-rules = [{
            matches = [{ app-id = "dev.noctalia.Noctalia"; }];
            open-floating = false;
            default-column-width.fixed = 1080;
            default-window-height.fixed = 920;
          }];

          # Lets Noctalia activate windows and notification actions.
          debug.honor-xdg-activation-with-invalid-serial = [ ];

          # Lets X11 apps such as Steam run. niri starts it on demand.
          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          # Mod is the Super key. Run `niri msg action` for the full list of actions.
          binds = {
            # Noctalia. Run `noctalia msg --help` for every command.
            "Mod+Space" = {
              action = noctalia "panel-toggle launcher";
              hotkey-overlay.title = "App launcher";
            };
            "Mod+S".action = noctalia "panel-toggle control-center";
            "Mod+V".action = noctalia "panel-toggle clipboard";
            "Mod+X".action = noctalia "panel-toggle session";
            "Mod+Comma".action = noctalia "settings-toggle";
            "Mod+Alt+L".action = noctalia "session lock";
            "XF86AudioRaiseVolume" = { action = noctalia "volume-up"; allow-when-locked = true; };
            "XF86AudioLowerVolume" = { action = noctalia "volume-down"; allow-when-locked = true; };
            "XF86AudioMute" = { action = noctalia "volume-mute"; allow-when-locked = true; };
            "XF86MonBrightnessUp" = { action = noctalia "brightness-up"; allow-when-locked = true; };
            "XF86MonBrightnessDown" = { action = noctalia "brightness-down"; allow-when-locked = true; };

            "Mod+Shift+Slash" = {
              action.show-hotkey-overlay = [ ];
              hotkey-overlay.title = "Show these shortcuts";
            };

            # Apps
            "Mod+T" = {
              action.spawn = terminal;
              hotkey-overlay.title = "Open a terminal";
            };
            "Mod+Q" = {
              action.close-window = [ ];
              hotkey-overlay.title = "Close the window";
            };
            "Mod+Shift+E" = {
              action.quit = [ ];
              hotkey-overlay.title = "Quit niri";
            };

            # Move around. Arrow keys and vim keys both work.
            "Mod+Left".action.focus-column-left = [ ];
            "Mod+Right".action.focus-column-right = [ ];
            "Mod+Up".action.focus-window-up = [ ];
            "Mod+Down".action.focus-window-down = [ ];
            "Mod+H".action.focus-column-left = [ ];
            "Mod+L".action.focus-column-right = [ ];
            "Mod+K".action.focus-window-up = [ ];
            "Mod+J".action.focus-window-down = [ ];

            # Rearrange
            "Mod+Ctrl+Left".action.move-column-left = [ ];
            "Mod+Ctrl+Right".action.move-column-right = [ ];
            "Mod+Ctrl+Up".action.move-window-up = [ ];
            "Mod+Ctrl+Down".action.move-window-down = [ ];
            "Mod+Ctrl+H".action.move-column-left = [ ];
            "Mod+Ctrl+L".action.move-column-right = [ ];
            "Mod+Ctrl+K".action.move-window-up = [ ];
            "Mod+Ctrl+J".action.move-window-down = [ ];

            # Workspaces and overview
            "Mod+Page_Down".action.focus-workspace-down = [ ];
            "Mod+Page_Up".action.focus-workspace-up = [ ];
            "Mod+O".action.toggle-overview = [ ];

            # Window size
            "Mod+R".action.switch-preset-column-width = [ ];
            "Mod+F".action.maximize-column = [ ];
            "Mod+Shift+F".action.fullscreen-window = [ ];
            "Mod+C".action.center-column = [ ];
            "Mod+Shift+Space".action.toggle-window-floating = [ ];

            # Screenshots
            "Print".action.screenshot = [ ];
            "Ctrl+Print".action.screenshot-screen = [ ];
            "Alt+Print".action.screenshot-window = [ ];
          } // workspaceBinds;
        };
      };

      # Shell
      programs.noctalia = {
        enable = true;
        # Start the shell with the graphical session.
        systemd.enable = true;
        # Anything left out keeps Noctalia's default. The file is checked when you build, and
        # every setting is documented in the example.toml in the noctalia repo.
        # Changes made in the shell's settings window (Mod+Comma) persist on top of this.
        settings = {
          shell = {
            font_family = "Inter";
            # Show authentication prompts, for example when mounting a drive.
            polkit_agent = true;
          };

          theme =  {
            templates = {enable_builtin_templates = true; builtin_ids = ["niri" "gtk3" "gtk4" "qt" "kitty" "helix" "btop"];};
          };
          # theme = { mode = "dark"; source = "builtin"; builtin = "Nord"; };
          # bar.main.position = "top";
        };
      };
programs.kitty = {

      # Apps and helpers the desktop expects.
      enable = true;
      extraConfig = ''
        include themes/noctalia.conf
      '';
};
      programs.firefox.enable = true;
      home.packages = [ pkgs.wl-clipboard ]
        # On NixOS these come from the system, on other Linux the user profile has to bring them.
        ++ lib.optionals (!onSystem) [ pkgs.inter ];
      fonts.fontconfig.enable = lib.mkIf (!onSystem) true;

      home.sessionVariables.NIXOS_OZONE_WL = "1";

      # On non-NixOS Linux this fixes XDG paths and links the GPU drivers.
      targets.genericLinux.enable = lib.mkDefault (!onSystem);
    })
  ]);
}
