#!/bin/sh

mkdir ./flutter/.pub-cache/

cat <<EOF > ./flutter/.pub-cache/credentials.json 
{
  "accessToken":"$accessToken",
  "refreshToken":"$refreshToken",
  "tokenEndpoint":"https://accounts.google.com/o/oauth2/token",
  "scopes":["openid","https://www.googleapis.com/auth/userinfo.email"],
  "expiration":1564090897608
}
EOF

./flutter/bin/flutter pub pub publish -f -v