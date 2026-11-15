{config, pkgs, ...}: {
  networking.networkmanager.dns = "none";
  services.dnsmasq = {
    enable  = true;
    resolveLocalQueries = true;
    settings = {
      listen-address = "127.0.0.1";
      bind-interfaces = true;
      no-resolv = true;
      strict-order = true;
      server = [
        "ts/.net/100.100.100.100"
        "100.92.245.95"
        "9.9.9.9"
      ];
      
    };
  };
}
