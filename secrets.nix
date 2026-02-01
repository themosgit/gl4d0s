let
  keys = import ./hosts/gl4dos-pub.nix;
  all_keys = [ keys.gl4dos keys.themos-gl4dos ];
in
{
 "secrets/litellm-env.age".publicKeys = all_keys;
 "secrets/cloudflare-token.age".publicKeys = all_keys;
 "secrets/redis-pass.age".publicKeys = all_keys;
}
