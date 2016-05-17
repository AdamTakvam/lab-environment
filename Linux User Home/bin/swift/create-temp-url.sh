#!/bin/bash

if [ -z "$1" ]; then
  echo "You must specify a path (e.g. /v1/AUTH-support/container/file)"
  exit
fi

META_KEY=$(swift stat 2>null | awk -F: '{ if(match($1, "Temp-Url-Key")) print $2}')

if [ -z "$META_KEY" ]; then
  echo "Failed to query metadata key from account information"
  exit
fi

# Create a URL valid for 1 month
swift tempurl GET 2592000 "$1" $META_KEY

# TODO: Prefix the storage hostname to the returned path
