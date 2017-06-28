#!/bin/sh
# before run install systemwide packages with homebrew:
# wget, jsonpp, jq
#
# Download photos and videos
# KID_ID=11111
# SINCE=2017-05-12T00:00:00.000Z
# TOKEN=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
# 
# Set correct ids to env variables and run from a terminal:
# KID_ID=11111 SINCE=2017-05-12T00:00:00.000Z # TOKEN=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa ./photovideo_downloader.sh
#
# To download 1seconds use this base_url
# 'https://babyalbum.com/api/kids/$KID_ID/daily_snapshots?locale=ru&token=$TOKEN'

curl "https://babyalbum.com/api/kids/$KID_ID/events?locale=ru&since=$SINCE&token=$TOKEN" \
     -H 'Accept-Encoding: gzip, deflate, sdch, br' \
     -H 'Accept-Language: ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4' \
     -H 'Upgrade-Insecure-Requests: 1' \
     -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36' \
     -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
     -H 'Cache-Control: max-age=0' \
     -H 'Connection: keep-alive' \
     --compressed -o photos_unpretty.json
jsonpp photos_unpretty.json > photos.json && rm -rf photos_unpretty.json
jq '.[].details.media[].unprocessed_url' photos.json | tr -d '""' > photos.tmp
cut -d ? -f 1 photos.tmp > photos.txt
rm -rf photos.tmp
mkdir -pv photos
cd photos && rm -rf *.*
wget -i ../photos.txt
cd ..
rm -rf photos.*
