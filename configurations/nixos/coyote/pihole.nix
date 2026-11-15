{config, pkgs, ...}: {
  services.pihole-ftl = {
    enable = true;
    settings.dns = {
      upstreams = [ "1.1.1.1" "9.9.9.9" ];
      listeningMode = "ALL";
      rateLimit = {
        count = 20000;
        interval = 60;
      };
    };
    lists = [
      {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
      }
    ];
  };

  services.pihole-web = {
    enable = true;
    ports = [ 8080 ];
  };
}
