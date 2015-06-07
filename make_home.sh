#!/bin/sh
# ------------------------------------------------------------------
# Author: John Oliphant 
# Title:  make_home.sh
# Descr:  Git based linux home config script.  Script will fully
#         configure a users home directory and install home configs.
#         This is my personal version, not all configs will apply.
# ------------------------------------------------------------------

# Set some safety flags
set -o nounset  # variables must be set
set -o errexit  # kill execution on error

# Arch base packages
archBase=('wget' 'git' 'vim')

# Arch xfce packages
archXfce=('kupfer' 'geany' 'geany-themes' 'vmware-horizon-client'
          'cataclysm-dda-git')

# Arch Gnome packages
archGnome=('evopop-gtk-theme' 'geany' 'evopop-icon-theme'
           'vmware-horizon-client' 'cataclysm-dda-git')
   
# Check to see if package is installed        
alreadyInstalled() {
  pacman -Qi -- "$1" &>/dev/null
}

# Check to see if group is installed        
groupAlreadyInstalled() {
  pacman -Qg -- "$1" &>/dev/null
}

# Install function
# Uses Packer
pkgInstall () {
   if alreadyInstalled "$arpkg";
   then
       echo "Ooops $arpkg is already installed, skipping"
       pkgInstalled="True"
   else
      echo "$arpkg has not been installed, installing"
      packer -S $arpkg --noconfirm
      pkgInstalled="False"
   fi
}

# ARCH configuration
echo "Is this an ARCH build? (y,n)"
read ARCH
if [ $ARCH == "y" ]
then
   echo "Setting up ARCH..."
   
   #  Is this a 32bit or 64bit architecture?
   echo "Checking architecture..."
   case $(uname -m) in
      x86_64) BITS=64 ;;
      i*86) BITS=32 ;;
         *) BITS=? ;;
   esac
   
   # If 64bit enable multilib
   if [ $BITS = 64 ]
   then
      sudo sed -i -e 's/#\[multilib]/[multilib]/g' -e '/\[multilib]/!b;n
         cInclude = \/etc\/pacman.d\/mirrorlist' /etc/pacman.conf
      echo "Found 64 bit architecture, multilib enabled."
   else
      echo "Found 32 bit, no changes needed."
   fi

   # Full system update
   echo "Updating system."
   sudo pacman -Syu --needed --noconfirm
   
   # Check for base-devel package
   echo "Getting base developement packages."
   arpkg="base-devel"
   
   if groupAlreadyInstalled "$arpkg";
   then
      echo "Base-devel already installed, moving on."
   else
      sudo pacman -S "$arpkg" --needed --noconfirm 
   fi

   # Get Packer
   # Bash wrapper for pacman and aur
   echo "Getting Packer" 
   arpkg="packer"

   if alreadyInstalled "$arpkg";
   then
      echo "Packer already here, moving on."
   else
      cd ~/
      wget https://aur.archlinux.org/packages/pa/packer/packer.tar.gz
      tar -xvf packer.tar.gz
      cd packer
      makepkg -s
      sudo pacman -U packer*.pkg.tar.xz
   fi
   
   # Install the base packages
   for arpkg in "${archBase[@]}"
   do
      pkgInstall "$arpkg"
   done

else
   echo "No Arch?  Moving on then."
fi

# Copy config files to home
cd ~/linux_home_config
echo "Copying configs to home ..."
cp .bashrc ~/     && echo ".bashrc"
cp .gitconfig ~/  && echo ".gitconfig"
cp .vimrc ~/      && echo ".vimrc"
cp .minttyrc ~/   && echo ".minttyrc"

# Source our bashrc to make ourselves at home
source ~/.bashrc

# All's well that ends well.
echo "Script compeleted"








