{ config, pkgs, ... }:

{ config, pkgs, ... }:

let
  hydraSecret = file: {
    sopsFile = ../../../secrets/${file};
    format = "binary";
    owner = "hydra";
    group = "hydra";
    mode = "0400";
  };
in
{
  sops.secrets = {
    r2-access-key = hydraSecret "r2-access-key";
    r2-secret-key = hydraSecret "r2-secret-key";
    niks3-signing-key = hydraSecret "niks3-signing-key";
    niks3-api-token = hydraSecret "niks3-api-token";
  };

  services.niks3 = {
    enable = true;
    httpAddr = "127.0.0.1:5751";

    s3 = {
      endpoint = "dd6698bb63c72ea85b3dfa92c0b0c18d.r2.cloudflarestorage.com";
      bucket = "fuzzflakes-cache";
      region = "auto";
      useSSL = true;
      accessKeyFile = config.sops.secrets.r2-access-key.path;
      secretKeyFile = config.sops.secrets.r2-secret-key.path;
    };

    apiTokenFile = config.sops.secrets.niks3-api-token.path;
    signKeyFiles = [ config.sops.secrets.niks3-signing-key.path ];

    gc = {
      enable = true;
      olderThan = "720h";
      failedUploadsOlderThan = "6h";
      schedule = "daily";
    };
  };
}
