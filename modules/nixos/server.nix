# Defaults for an always-on, headless machine, switched on with `me.server.enable = true;`
#
# Goals are to recover alone after a hang, crash or power cut, never sleep, and not fill
# the disk. Two things cannot be set from Nix and live in the BIOS
#   After power loss   set to "Power on" so the box returns after an outage
#   Watchdog           leave any hardware watchdog setting enabled
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.me.server;
in
{
  options.me.server.enable = lib.mkEnableOption "headless server defaults (self-recovery, no sleep, disk hygiene)";

  config = lib.mkIf cfg.enable {
    # A desktop-class PC has no business suspending.
    systemd.targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };

    # Reboot automatically if systemd stops responding, or if a shutdown hangs.
    systemd.settings.Manager = {
      RuntimeWatchdogSec = "30s";
      RebootWatchdogSec = "10min";
    };

    # Reboot ten seconds after a kernel panic or oops instead of sitting dead.
    boot.kernel.sysctl = {
      "kernel.panic" = 10;
      "kernel.panic_on_oops" = 1;
    };

    # Keep the (small, FAT) boot partition from filling up with old generations.
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.tmp.cleanOnBoot = true;

    # Disk hygiene. System level, so it runs without anyone being logged in.
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    nix.optimise.automatic = true;
    services.journald.settings.Journal.SystemMaxUse = "500M";
    services.fstrim.enable = true;

    # Early warning for a dying drive. Check with `sudo smartctl -a /dev/nvme0n1`.
    services.smartd.enable = true;

    # Compressed swap in RAM, on top of the swap partition.
    zramSwap.enable = true;

    environment.systemPackages = with pkgs; [
      zellij
      btop
      smartmontools
    ];
  };
}
