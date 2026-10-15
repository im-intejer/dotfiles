# Settings specific to this one machine, an Intel MacBook with Broadcom Wi-Fi.
# Reusable pieces live in /modules/nixos/ and the hardware scan lives in ./hardware-configuration.nix
# Options are documented in configuration.nix(5) and at https://search.nixos.org/options
{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # UEFI boot loader
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi = {
        backend = "wpa_supplicant";
        powersave = false;
      };
    };
    # The Wi-Fi interface of this machine
    useDHCP = false;
    interfaces.wlp3s0.useDHCP = true;
  };

  # Do not hold up boot while waiting for the network.
  systemd.services.NetworkManager-wait-online.enable = false;

  # The Broadcom driver and firmware are unfree.
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  # Extra groups for the main user. The account itself comes from `myusers`.
  users.users.upwrd.extraGroups = [
    "networkmanager"
    "wheel"
  ];

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  # Leave this at the release of the first install. Read `man configuration.nix` before changing it.
  system.stateVersion = "20.09";
}
