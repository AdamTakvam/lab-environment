#!/bin/bash

P1="/sbin"
P2="/usr/sbin"
P3="/usr/local/sbin"

if [[ ! $PATH =~ "$P1" ]]; then
  PATH=$P1:$PATH
fi

if [[ ! $PATH =~ "$P2" ]]; then
  PATH=$P2:$PATH
fi

if [[ ! $PATH =~ "$P3" ]]; then
  PATH=$P3:$PATH
fi
unset P1
unset P2
unset P3
