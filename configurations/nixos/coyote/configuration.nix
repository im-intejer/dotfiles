# Settings specific to this one machine, an HP EliteDesk 800 G4 running headless.
# Reusable pieces live in /modules/nixos/ and the hardware scan lives in ./hardware-configuration.nix
# Options are documented in configuration.nix(5) and at https://search.nixos.org/options
{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common/tailscale.nix
    ./pihole.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "coyote";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };

  services.tailscale = {
    useRoutingFeatures = "server";
    extraSetFlags = [ "--advertise-exit-node" "--accept-dns=false"];
  };

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # The account itself comes from `myusers`.
  users.users.upwrd = {
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP8F0zWwhg4pmbR7m9NuiJIttD00J9QiSxJ8ps0/0W7u upwrd@fox"
    ];
  };
  environment = {
    systemPackages = with pkgs; [
      vim
      git
      kitty.terminfo
    ];
  };

  # Key only login. Port 22 is opened once, here, for the LAN. Tailscale traffic is
  # already allowed through its trusted interface, so SSH also works over the tailnet.
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "upwrd" ];
      MaxAuthTries = 3;
      X11Forwarding = false;
      # Drop dead sessions after about three minutes instead of leaving them hanging.
      ClientAliveInterval = 60;
      ClientAliveCountMax = 3;
      PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
    };
  };

  # Leave this at the release of the first install. Read `man configuration.nix` before changing it.
  system.stateVersion = "26.05";
}
