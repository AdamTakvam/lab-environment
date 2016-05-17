#!/bin/bash

if [ -d ~/init.d ]; then
  for i in ~/init.d/*.sh ; do
    if [ -r "$i" ]; then
      source "$i"
    fi
  done
  unset i
fi