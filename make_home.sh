#!/bin/bash

# config script

# Arch base packages
ArchBase=('' '')

# Arch xfce packages
ArchXfce=('' '')

# Arch Gnome packages
ArchGnome=('' '')

#CYGWIN=`uname | grep -o 'CYGWIN'`
#echo "$CYGWIN is the env"

# If system is ARCH let's get some stuff
echo "Is this an ARCH build?"
read ARCH

if [ $ARCH == "y" ]
then
   echo "Setting up ARCH..."
   echo "Checking architecture..."
   # 64 or 32 bit?
   case $(uname -m) in
      x86_64)
      BITS=64
         ;;
      i*86)
      BITS=32
         ;;
         *)
      BITS=?
    ;;
   esac

   if [ $BITS = 64 ]
   then
      # Enable multilib repo
      sudo sed -i -e "s/#\[multilib]/[multilib]/g" -e "s/#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/g" /etc/pacman.conf
      echo "Found 64 bit architecture, enabling multilib."
   fi

   echo "Updating system."
   sudo pacman -Syu --needed --noconfirm

   echo "Getting Packer."
   arpkg="packer"
   CheckInstall $arpkg

   if [ $pkgInstalled -a "False" ]
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

# Check and Install function
# Uses Packer
CheckInstall () {
   pkgInstalled=`pacman -Qi $1 | grep -o 'Name'`
   echo "$pkgInstalled"
   if [ $pkgInstalled -a "Name" ]
   then
       echo "Ooops $arpkg is already installed, skipping"
       pkgInstalled="True"
   else
      echo "Oops $arpkg has not been installed, installing"
      packer -S $arpkg --noconfirm --noedit
      pkgInstalled="False"
   fi
   echo "$pkgInstalled"
}







