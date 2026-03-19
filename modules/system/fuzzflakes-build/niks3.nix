{ config, pkgs, ... }:

let
  niks3-secrets = file: {
    sopsFile = ../../../secrets/${file};
    format = "binary";
    owner = "niks3";
    group = "niks3";
    mode = "0400";
  };
  postBuildHook = pkgs.writeShellScript "niks3-post-build-hook" ''
    set -euf
    export NIKS3_SERVER_URL="http://127.0.0.1:5751"
    export NIKS3_AUTH_TOKEN_FILE="${config.sops.secrets.niks3-api-token.path}"

    echo "$OUT_PATHS" | xargs ${pkgs.niks3}/bin/niks3 push
  '';

in
{
  sops.secrets = {
    r2-access-key = niks3-secrets "r2-access-key";
    r2-secret-key = niks3-secrets "r2-secret-key";
    niks3-signing-key = niks3-secrets "niks3-signing-key";
    niks3-api-token = niks3-secrets "niks3-api-token";
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


  nix.settings = {
    extra-substituters = [ "http://127.0.0.1:5751" ];
    extra-trusted-public-keys = [
      "fuzzflakes-cache:+wlHdD6xWnHIk64d0DJbG2BeovPgrdfdOkeXH/gBpgg="
    ];
  };
}
