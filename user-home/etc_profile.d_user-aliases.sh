#!/bin/bash

if [ -d ~/alias.d ]; then
  for i in ~/alias.d/*.sh ; do
    if [ -r "$i" ]; then
      source "$i" >/dev/null
    fi
  done
  unset i
fi
