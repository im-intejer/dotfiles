{ config, pkgs, ... }: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    extraSetFlags = [ "--advertise-exit-node" ];
  };

  networking = {
    nftables.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];

    };
  };
  
  systemd = {

    services.tailscaled.serviceConfig.Environment = [ "TS_DEBUG_FIREWALL_MODE=nftables" ];
    network.wait-online.enable = false;
  };
  
  boot.initrd.systemd.network.wait-online.enable = false;
}
