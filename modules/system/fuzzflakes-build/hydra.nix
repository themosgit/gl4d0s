{ config, pkgs, lib, ... }:

let
  postBuildHook = pkgs.writeShellScript "niks3-post-build-hook" ''
    set -euf
    export NIKS3_SERVER_URL="http://127.0.0.1:5751"
    export NIKS3_AUTH_TOKEN_FILE="${config.sops.secrets.niks3-api-token.path}"

    echo "$OUT_PATHS" | xargs ${pkgs.niks3}/bin/niks3 push
  '';
in
{
  sops.secrets.hydra-github-ssh = {
    sopsFile = ../../../secrets/hydra-github-ssh;
    format = "binary";
    owner = "hydra";
    group = "hydra";
    mode = "0400";
  };

  services.hydra = {
    enable = false;
    hydraURL = "https://hydra.gl4dos.com";
    notificationSender = "hydra@gl4dos.com";
    useSubstitutes = true;
    minimumDiskFree = 100;
    minimumDiskFreeEvaluator = 60;
    extraConfig = ''
      evaluator_workers = 3
      max_concurrent_evals = 2
      max_db_connections = 128
      evaluator_max_memory_size = 4096
      max_output_size = 4294967296
      upload_logs_to_binary_cache = true
    '';
  };

  nix.settings = {
    post-build-hook = "${postBuildHook}";
    extra-substituters = [ "http://127.0.0.1:5751" ];
    extra-trusted-public-keys = [
      "fuzzflakes-cache:+wlHdD6xWnHIk64d0DJbG2BeovPgrdfdOkeXH/gBpgg="
    ];
  };

  nix.buildMachines = [
    {
      hostName = "localhost";
      systems = [ "x86_64-linux" ];
      maxJobs = 32;
      supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
    }
  ]; 
}
