{ pkgs, config, ... }:

let
    attic-server-patched = pkgs.attic-server.overrideAttrs (old: {
        patches = (old.patches or []) ++ [
            (pkgs.fetchpatch {
                      url = "https://github.com/zhaofengli/attic/compare/main...CobaltCause:attic:push-tosltrzqummr.patch";
		      hash = "sha256-QQELAVemcIQ5e8UlvdeXjdbJPqRbU4W4z7QSOGdw40A=";
        })
    ];
});
in
{
  age.secrets.attic-credentials = {
      file = ../../secrets/attic-credentials.age;
      owner = "atticd";
      group = "atticd";
  };

  environment.systemPackages = [ pkgs.attic-client ];

  services.atticd = {
    enable = true;
    package = attic-server-patched;

    environmentFile = config.age.secrets.attic-credentials.path;

    settings = {
      listen = "[::]:8080";

      storage = {
        type = "s3";
        bucket = "fuzzflakes-cache";
        region = "eu-north-1";
      };

        chunking = {
          nar-size-threshold = 0;
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
