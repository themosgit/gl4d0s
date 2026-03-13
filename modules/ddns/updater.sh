#!/bin/bash

auth_email=$CLOUDFLARE_EMAIL                     # The email used to login 'https://dash.cloudflare.com'
auth_method="global"                                 # Set to "global" for Global API Key or "token" for Scoped API Token
auth_key=$AUTH_KEY     # Your API Token or Global API Key
zone_identifier=$ZONE_ID   # Can be found in the "Overview" tab of your domain
record_name=$RECORD_NAME                         # Which record you want to be synced
ttl=3600                                             # Set the DNS TTL (seconds)
proxy="false"                                        # Set the proxy to true or false
sitename=""                                          # Title of site "Example Site"
slackchannel=""                                      # Slack Channel #example
slackuri=""                                          # URI for Slack WebHook "https://hooks.slack.com/services/xxxxx"
discorduri=""                                        # URI for Discord WebHook "https://discordapp.com/api/webhooks/xxxxx"


REGEX_IPV4="^(0*(1?[0-9]{1,2}|2([0-4][0-9]|5[0-5]))\.){3}0*(1?[0-9]{1,2}|2([0-4][0-9]|5[0-5]))$"
IP_SERVICES=(
  "https://api.ipify.org"
  "https://ipv4.icanhazip.com"
  "https://ipinfo.io/ip"
)

for service in ${IP_SERVICES[@]}; do
  RAW_IP=$(curl -s $service)
  if [[ $RAW_IP =~ $REGEX_IPV4 ]]; then
    CURRENT_IP=$BASH_REMATCH
    logger -s "DDNS Updater: Fetched IP $CURRENT_IP"
    break
  else
    logger -s "DDNS Updater: IP service $service failed."
  fi
done

logger -s "checking if the current ip is valid..."
# Exit if IP fetching failed
if [[ -z "$CURRENT_IP" ]]; then
  logger -s "DDNS Updater: Failed to find a valid IP."
  exit 2
fi

logger -s "valid ip proceeding to prepapring auth header..."

if [[ "${auth_method}" == "global" ]]; then
  auth_header="X-Auth-Key:"
else
  auth_header="Authorization: Bearer"
fi

logger -s "auth header ready."

logger -s "DDNS Updater: Check Initiated"
record=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?type=A&name=$record_name" \
                      -H "X-Auth-Email: $auth_email" \
                      -H "$auth_header $auth_key" \
                      -H "Content-Type: application/json")


if [[ $record == *"\"count\":0"* ]]; then
  logger -s "DDNS Updater: Record does not exist, perhaps create one first? (${CURRENT_IP} for ${record_name})"
  exit 1
fi

logger -s "check complete record fetched."
old_ip=$(echo "$record" | sed -E 's/.*"content":"(([0-9]{1,3}\.){3}[0-9]{1,3})".*/\1/')
if [[ $CURRENT_IP == $old_ip ]]; then
  logger -s "DDNS Updater: IP ($CURRENT_IP) for ${record_name} has not changed."
  exit 0
fi
logger -s "ip has changed"
record_identifier=$(echo "$record" | sed -E 's/.*"id":"([A-Za-z0-9_]+)".*/\1/')

echo $record_identifier 
update=$(curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier" \
                     -H "X-Auth-Email: $auth_email" \
                     -H "$auth_header $auth_key" \
                     -H "Content-Type: application/json" \
                     --data "{\"type\":\"A\",\"name\":\"$record_name\",\"content\":\"$CURRENT_IP\",\"ttl\":$ttl,\"proxied\":${proxy}}")

case "$update" in
*"\"success\":false"*)
  echo -e "DDNS Updater: $CURRENT_IP $record_name DDNS failed for $record_identifier ($CURRENT_IP). DUMPING RESULTS:\n$update" | logger -s 
  exit 1;;
*)
  logger -s "DDNS Updater: $CURRENT_IP $record_name DDNS updated."
  exit 0;;
esac
