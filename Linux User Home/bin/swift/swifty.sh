#!/bin/bash
if [ -z $1 -o -z $2 ]; then
  echo "Usage: swifty [download | upload] <file/object name>"
  exit 1
fi

TOKEN=$(curl -i $ST_AUTH -H "X-Auth-User: $ST_USER" -H "X-Auth-Key: $ST_KEY" 2> /dev/null | awk '{ if($1=="X-Auth-Token:") { print $2 } }')
echo $TOKEN

if [ $1 == 'download' ]; then
 
else if [$1 == 'upload' ]; then

else
  echo "Operation not supported"
fi

