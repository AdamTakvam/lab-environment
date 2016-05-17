BIN_PATH=/home/`whoami`/bin
if [[ ! $PATH =~ "$BIN_PATH" ]]; then
  export PATH="${PATH}:${BIN_PATH}"
fi
unset BIN_PATH

export LIB_PATH=${LIB_PATH:-"/home/`whoami`/lib"}