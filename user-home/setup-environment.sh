#!/bin/bash

if [ ! -f ~/etc_profile.d_user-aliases.sh ]
  then echo "Error: Environment has already been initialized."
  exit 1
fi

# Install OS-specific & admin aliases
OS="EL"
echo "Installing admin aliases..."
if [ -f /etc/redhat-release ]; then
  if [ "$(grep '7.' /etc/redhat-release)" ]; then
  	echo "CentOS/RHEL 7.x detected."
    cat ~/alias.d/admin-aliases-common.sh ~/alias.d/admin-aliases-el7.sh > ~/alias.d/admin-aliases.sh
  else
  	echo "CentOS/RHEL 6.x detected."
    cat ~/alias.d/admin-aliases-common.sh ~/alias.d/admin-aliases-el6.sh > ~/alias.d/admin-aliases.sh
  fi
elif [ -f /etc/os-release ]; then
  OS="Ubuntu"
  if [ "$(grep '16.' /etc/os-release)" ]; then
  	echo "Ubuntu 16.04+ detected."
    cat ~/alias.d/admin-aliases-common.sh ~/alias.d/admin-aliases-ubuntu16.sh > ~/alias.d/admin-aliases.sh
  else
  	echo "Ubuntu 14.x/15.x detected."
    cat ~/alias.d/admin-aliases-common.sh ~/alias.d/admin-aliases-ubuntu14.sh > ~/alias.d/admin-aliases.sh
  fi
else
  echo "Error: Could not determine the OS version"
  exit 1
fi
rm ~/alias.d/admin-aliases-*

# Install /bin scripts
SPEC_BIN=`find ~/bin -mindepth 1 -type d -printf '%P\n' 2> /dev/null`
for PROG in $SPEC_BIN; do
  echo -n "Do you want to install $PROG client scripts (y/N)? "
  read choice
  if [[ "${choice,,}" =~ "y" ]]; then
    mv ~/bin/$PROG/* ~/bin/

    # Special case: Swift
    if [ "$PROG" == "swift" ]; then
      # Install the Swift client environment matching this user as default on login
      swift_env="~/bin/$(whoami)-env.sh"
      if [ -f "$swift_env" ]; then
        cp "$swift_env" ~/init.d/
      fi
      unset swift_env
    fi

    # Install special aliases (if applicable)
    if [ 0 -lt $(ls ~/alias.d/special/$PROG-*.sh 2> /dev/null | wc -l) ]; then
      mv ~/alias.d/special/$PROG-* ~/alias.d/
    fi
  else
    # Don't bother installing the aliases
    if [ 0 -lt $(ls ~/alias.d/special/$PROG-*.sh 2> /dev/null | wc -l) ]; then
      rm -f ~/alias.d/special/$PROG-*
    elif [ 0 -lt $(ls ~/alias.d/$PROG-*.sh 2> /dev/null | wc -l) ]; then
      rm -f ~/alias.d/$PROG-*
    fi
  fi
  rm -rf ~/bin/$PROG
done
unset SPEC_BIN

# Set installed /bin scripts to executable
if [ 0 -lt $(ls ~/bin/ 2> /dev/null | wc -l) ]; then
  chmod a+x ~/bin/*
fi

# Install special aliases
SPEC_ALIASES=`ls ~/alias.d/special/ 2> /dev/null | cut -d - -f 1 | sort -u`
for PROG in $SPEC_ALIASES; do
  echo -n "Do you want to install $PROG aliases (y/N)? "
  read choice
  if [[ "${choice,,}" =~ "y" ]]; then
    mv ~/alias.d/special/$PROG-* ~/alias.d/
  fi
done
rm -rf ~/alias.d/special


# Install user config files
echo "Installing user config files..."
if [ -f ~/gitconfig ]; then
  mv ~/gitconfig ~/.gitconfig
fi
# TODO: Get the .vimrc settings right first
#if [ -f ~/vimrc ]; then
#  mv ~/vimrc ~/.vimrc
#fi

# Install scripts which cause ~/alias.d and ~/init.d to be sourced on login
sudo mv ~/etc_profile.d_user-aliases.sh /etc/profile.d/user-aliases.sh
sudo mv ~/etc_profile.d_user-init.sh /etc/profile.d/user-init.sh
sudo chmod a+x /etc/profile.d/user-*.sh

echo "Installing packages..."
PACKAGES="vim net-tools nmap lsof git"
if [ "$OS" == "Ubuntu" ]; then
  sudo apt update
  sudo apt-get install -y "$PACKAGES"
else
  sudo yum install -y "epel-release $PACKAGES"
fi

echo "Environment setup complete."
echo "Log out and back in to load the new environment."