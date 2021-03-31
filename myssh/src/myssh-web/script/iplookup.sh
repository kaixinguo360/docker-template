#!/bin/sh

cd $(dirname $0)

[ -z "$IPSTACK_ACCESS_KEY" ] \
    && echo "[ERROR] IPSTACK_ACCESS_KEY not set" >&2 \
    && exit 1

IP=$1
TABLE=$2
ACCESS_KEY=$IPSTACK_ACCESS_KEY

printf 'Fetching ip info: %s' "$1" >&2
#JSON=$(curl -sS http://api.db-ip.com/v2/free/$IP)
JSON=$(curl -sS http://api.ipstack.com/${IP}?access_key=$ACCESS_KEY)
printf '\n' >&2

continent_code=$(echo $JSON | jq .continent_code)
continent_name=$(echo $JSON | jq .continent_name)
country_code=$(echo $JSON | jq .country_code)
country_name=$(echo $JSON | jq .country_name)
region_code=$(echo $JSON | jq .region_code)
region_name=$(echo $JSON | jq .region_name)
city=$(echo $JSON | jq .city)

zip=$(echo $JSON | jq .zip)

latitude=$(echo $JSON | jq .latitude)
longitude=$(echo $JSON | jq .longitude)

geoname_id=$(echo $JSON | jq .location.geoname_id)



echo "\
REPLACE INTO $TABLE 
    (ip, continent_code, continent_name, country_code, country_name, region_code, region_name, city, zip, latitude, longitude, geoname_id) 
VALUES 
    ('$IP', $continent_code, $continent_name, $country_code, $country_name, $region_code, $region_name, $city, $zip, $latitude, $longitude, $geoname_id);"
