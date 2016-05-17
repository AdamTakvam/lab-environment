# Source me!

function portinfo
{
  PORT=$1

  if [ -z "$PORT" ]
    then echo "Error: You must specify a port number."
    return 1
  fi

  echo "--- Port status ---"
  netstat -l --numeric-ports | grep $PORT

  echo
  echo "--- Port scan on localhost ---"
  nmap 127.0.0.1 -p $PORT | grep $PORT --before-context=1

  echo
  echo "--- Process(es) bound to $PORT ---"
  lsof -n -iTCP:$PORT

  unset PORT
}

function devinfo
{
  DEVICE=$1

  if [ -z "$DEVICE" ]
    then echo "Error: You must specify a device name."
    return 1
  fi

  DEVPATH=`find /sys/devices -name $DEVICE -printf '%P\n' | grep -v virtual`
  VDEVPATH=`find /sys/devices -name $DEVICE -printf '%P\n' | grep virtual | grep -v slaves`
  LVMTYPE=`sudo lvdisplay | grep -m 1 " $DEVICE$" | cut -d ' ' -f 3`

  if [ "$LVMTYPE" ]; then
    echo "Type: Logical (LVM)"

    if [ "$LVMTYPE" == "LV" ]; then
      VG=`find /dev -name $DEVICE | cut -d / -f 3`
      sudo lvdisplay "/dev/$VG/$DEVICE"
      sudo vgdisplay $VG
      unset VG
    elif [ "$LVMTYPE" == "VG" ]; then
      sudo vgdisplay $DEVICE
    fi # /LVM
  else
    if [ "$VDEVPATH" ]; then
      echo "Type: Virtual"
      echo "Path: $DEVPATH"

      if [ -r "$VDEVPATH/dm/name" ]
        then echo "Device mapper name: $(cat $VDEVPATH/dm/name)"
      fi
    else
      if [ "`echo $DEVICE | grep [1-9]$`" ]; then
        echo "Type: Physical (Partition)"
        echo "Path: $DEVPATH"

        if [ "`sudo pvdisplay | grep /dev/$DEVICE`" ]; then
          sudo pvdisplay /dev/$DEVICE
        fi

        if [ "`sudo zpool status 2> /dev/null | grep " $DEVICE"`" ]; then
          echo
          echo "ZFS Information:"
          sudo zpool status
        fi
      else
        echo "Type: Physical"
        echo "Path: $DEVPATH"

        if [ -r "$DEVPATH/device/model" ]
          then echo "Model: $(cat $DEVPATH/device/model)"
        fi
      fi
    fi
  fi

  unset DEVICE
  unset DEVPATH
  unset VDEVPATH
  unset LVMTYPE
}

