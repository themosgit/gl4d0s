{ config, ... }:

{
  sops.secrets.codestral-api-key = {
      sopsFile = ../secrets/codestral-api-key;
      format = "binary";
      owner = "themos";
  };
  environment.extraInit = ''
    if [ -r "${config.sops.secrets.codestral-api-key.path}" ]; then
        export CODESTRAL_API_KEY=$(cat "${config.sops.secrets.codestral-api-key.path}")
    fi || true
  '';
}
