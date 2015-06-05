#!/bin/bash

# config script

# Arch base packages
ArchBase=('geany' 'geany-themes' 'git' 'vim' 'vmware-horizon-client'
          'cataclysm-dda-git')

# Arch xfce packages
ArchXfce=('kupfer' '')

# Arch Gnome packages
ArchGnome=('evopop-gtk-theme' 'evopop-icon-theme' '')

# Check and Install function
# Uses Packer
CheckInstall () {
   pkgInstalled=null
   pkgInstalled=`pacman -Qi $1 | grep -o 'Name'`
   if [ $pkgInstalled -a "Name" ]
   then
       echo "Ooops $arpkg is already installed, skipping"
       pkgInstalled="True"
   else
      echo "$arpkg has not been installed, installing"
      packer -S $arpkg --noconfirm --noedit
      pkgInstalled="False"
   fi
}

#CYGWIN=`uname | grep -o 'CYGWIN'`
#echo "$CYGWIN is the env"

# If system is ARCH let's get some stuff
echo "Is this an ARCH build? (y,n)"
read ARCH

if [ $ARCH == "y" ]
then
   echo "Setting up ARCH..."
   echo "Checking architecture..."
   # 64 or 32 bit?
   case $(uname -m) in
      x86_64) BITS=64 ;;
      i*86) BITS=32 ;;
         *) BITS=? ;;
   esac

   if [ $BITS = 64 ]
   then
      # Enable multilib repo
      sudo sed -i -e "s/#\[multilib]/[multilib]/g" -e "s/#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/g" /etc/pacman.conf
      echo "Found 64 bit architecture, multilib enabled."
   else
      echo "Found 32 bit, no changes needed."
   fi

   echo "Updating system."
   sudo pacman -Syu --needed --noconfirm

   echo "Getting Packer."
   arpkg="packer"
   
   echo "$pkgInstalled"
   
   CheckInstall $arpkg

   if [ $pkgInstalled -a "True" ]
   then
      cd ~/
      wget https://aur.archlinux.org/packages/pa/packer/packer.tar.gz
      tar -xvf packer.tar.gz
      cd packer
      makepkg -s
      pacman -U packer.tar.xz
   fi

else
   echo "No Arch?  Moving on then."
fi

# Copy config files to home
echo "Copying configs to home"
cp .bashrc ~/
cp .gitconfig ~/
cp .vimrc ~/
cp .minttyrc ~/









