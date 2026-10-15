# dotfiles

One flake that configures a full NixOS desktop, a Mac, or any other Linux or macOS machine where Nix is only used as a package manager. It is built on [nixos-unified](https://nixos-unified.org), which wires every file under `configurations/` and `modules/` into a flake output automatically.

## What you get

| Where | What |
| --- | --- |
| NixOS | greetd login screen with the DankMaterialShell greeter, niri (Wayland), DankMaterialShell, Steam |
| macOS | nix-darwin plus your shell, git and editor setup |
| Any other OS | Home Manager only, with your shell, git and editor setup. The desktop is optional on Linux |

GNOME is not used anywhere.

## Layout

```
flake.nix                      inputs, nothing else
configurations/
  nixos/<host>/                one folder per NixOS machine
  darwin/<host>.nix            one file per Mac
  home/<user>.nix              one file per user, used by every machine above
modules/
  nixos/                       reusable NixOS modules (desktop.nix, gaming.nix, common/)
  darwin/                      reusable nix-darwin modules
  home/                        reusable Home Manager modules, all loaded automatically
```

The switches live in two places.

| Switch | Set in | Effect |
| --- | --- | --- |
| `me.desktop.enable` | NixOS host file, or the home file on other Linux | niri, DankMaterialShell and (on NixOS) the login screen |
| `me.gaming.enable` | NixOS host file | Steam, gamemode and gamescope |

On NixOS, `me.desktop.enable` also turns on the matching per-user setup, so there is one switch to flip.

## Using it

Run everything from a checkout of this repo. `just` lists the shortcuts.

### Full NixOS

The host is `configurations/nixos/nixos/`. Its name must equal the machine's hostname.

```sh
sudo nixos-rebuild switch --flake .#nixos
# or simply
just run
```

Log in through the new greeter and pick the niri session. Press `Mod+Space` for the launcher, `Mod+T` for a terminal and `Mod+Shift+/` for the full shortcut list. `Mod` is the Super key.

Steam is in the launcher. It needs X11, which niri provides through `xwayland-satellite`. That is already set up.

### macOS

Edit `configurations/darwin/macbook.nix` and make the file name match `scutil --get LocalHostName`. Set `nixpkgs.hostPlatform` for your chip and `myusers` for your account. Then

```sh
nix run nix-darwin -- switch --flake .#macbook   # first time
just run                                         # afterwards
```

The username in `myusers` needs a file at `configurations/home/<username>.nix`. Copy `upwrd.nix` and change the name.

### Nix as a package manager on any other OS

Install Nix with flakes enabled, then

```sh
just home
# which is the same as
nix run .#activate -- $USER@localhost
```

This applies `configurations/home/$USER.nix` only. It installs your CLI tools and dotfiles and touches nothing system wide.

To get niri and DankMaterialShell on another Linux distribution, add `desktop.enable = true;` in the `me` block of your home file. This is best effort. You still need to

1. Add a Wayland session that runs `niri-session` to your login manager.
2. Follow the GPU driver setup steps that Home Manager prints during activation, if it asks for them.

Steam is not set up in this mode. Use your distribution's package instead.

## Adding things

A new NixOS machine. Copy `configurations/nixos/nixos/` to a folder named after the hostname, replace `hardware-configuration.nix` with the output of `nixos-generate-config`, and edit `myusers` and the switches in `default.nix`.

A new user. Copy `configurations/home/upwrd.nix`, change the name and personal details, and list the name in `myusers` of each host that should have it.

A new package for every machine. Add it to `modules/home/packages.nix`. Desktop apps go in `modules/home/desktop.nix`.

## Customising the desktop

Keybinds, layout and input settings are in `modules/home/desktop.nix` under `programs.niri.settings`. The shell's own shortcuts come from DankMaterialShell. Its appearance can be changed from its settings panel (`Mod+Comma`), and the choices persist. The login screen picks up your shell theme and wallpaper from your home folder.

## Updating

```sh
just update    # refresh flake.lock
just run       # apply
```

Run `nix flake update` after pulling a change that adds inputs. DankMaterialShell follows current nixpkgs closely, so keep `nixpkgs` reasonably fresh.

## Troubleshooting

If the screen stays black after login, switch to a text console with `Ctrl+Alt+F2` and run `journalctl --user -u dms -b` and `journalctl -b -u greetd`.

If `me.desktop.enable` fails on a Mac, that is intended. niri and DankMaterialShell are Linux only.
