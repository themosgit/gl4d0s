{ pkgs, config, ... }:

{
  age.secrets.attic-credentials = {
      file = ../../secrets/attic-credentials.age;
      owner = "atticd";
      group = "atticd";
  };

  environment.systemPackages = [ pkgs.attic-client ];

  services.atticd = {
    enable = true;

    environmentFile = config.age.secrets.attic-credentials.path;

    settings = {
      listen = "[::]:8080";

      storage = {
        type = "s3";
        bucket = "fuzzflakes-cache";
        region = "eu-north-1";
      };

      chunking = {
        nar-size-threshold = 0; # chunking turned off caused ooms
        min-size = 16384;
        avg-size = 32768;
        max-size = 65536;
      };

      compression = {
        type = "zstd";
        level = 8;
      };

      database = {
        url = "sqlite:///var/lib/atticd/server.db?mode=rwc";
      };

      garbage-collection = {
        interval = "12 hours";
        default-retention-period = "6 months";
      };
    };
  };
}
