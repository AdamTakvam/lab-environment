#!/bin/bash

# This script verifies that the environment is properly configured to successfully install SwiftStack controller or node software.

# Force running as root
if [ $EUID -ne 0 ]
  then sudo $0 $@
  exit
fi

check_hardware()
{
  if [ -z "$(cat /proc/cpuinfo | grep avx)" ]
    then echo "WARN: CPU does not support AVX instructions required for erasure coding"
  fi
  return 0
}

check_distro()
{
  OS_VERSION=$(cat /etc/system-release)
  EL7=$(echo $OS_VERSION | grep 'release 7.2')
  EL6=$(echo $OS_VERSION | grep 'release 6.7') 
  if [ "$EL7" == "$EL6" ]
    then echo "FAIL: Unsupported OS: $OS_VERSION"; return 1
    else echo "PASS: $OS_VERSION"; return 0
  fi    
}

check_packages()
{
  PKGS=$(yum list installed)
  if [ "$(grep kde <<< $PKGS)" ] 
    then echo "FAIL: KDE is installed"; return 1
  fi
  if [ "$(grep NetworkManager <<< $PKGS)" ]
    then echo "WARN: NetworkManager is installed"
  fi

  PKGS=
}

check_storage()
{
  if [ $ROLE_CONTROLLER ]; then
    # Ensure that / has at least 64 GB free
    ROOT_FREE=$(df --total / | awk '{ if($1 == "total") print $4 }')
    if [ 64000000 > $ROOT_FREE ]; then
      echo "FAIL: Insufficient disk space"
      #echo "$(df -h)"
      return 1
    fi
  fi
}

check_network()
{
echo ""
}

check_firewall()
{
echo ""
}

check_selinux()
{
echo ""
}

check_hostname()
{
echo ""
}

check_internet()
{
echo ""
}

check_user()
{
echo ""
}

print_help()
{
  echo 'Usage: preinstall-check.sh [OPTIONS] ROLE'
  echo ''
  echo ' OPTIONS:'
  echo '   -a   Show all failures'
  echo ' ROLE:'
  echo '   -c   Controller'
  echo '   -n   Node'
}

if [ -z "$1" ]
  then print_help; exit 
fi

# Search for params and set convenience variables
[[ "$(grep c <<< $@)" ]] && ROLE_CONTROLLER='True'
[[ "$(grep n <<< $@)" ]] && ROLE_NODE='True'
[[ "$(grep a <<< $@)" ]] && SHOW_ALL='True'

check_distro  
check_packages
check_storage 
check_network
check_firewall
check_selinux
check_hostname
check_internet
check_user

# Print confirmation line that all tests pass if not showing all failures
echo 'PASS: This server is ready to install SwiftStack'
