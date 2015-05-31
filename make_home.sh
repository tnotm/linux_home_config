#!/bin/bash

# config script

#CYGWIN=`uname | grep -o 'CYGWIN'`
#echo "$CYGWIN is the env"

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

#echo  $BITS

# Copy config files to home
echo "Copying configs to home"
cp .bashrc ~/
cp .gitconfig ~/
cp .vimrc ~/
cp .minttyrc ~/


echo "Is this an initial ARCH build?"
read ARCH
echo "ARCH is $ARCH"

#if [ $ARCH = "y" ]
#then
#   echo "Setting up ARCH..."
#   echo "Updating system."
#   pacman -Syu
#   echo "Getting Packer."
#   cd ~/
#   wget https://aur.archlinux.org/packages/pa/packer/packer.tar.gz
#   tar -xvf packer.tar.gz
#   cd packer
#   makepkg -s
#   pacman -U packer.tar.xz
#fi

arpkg="packer"

CheckInstall () {
   pkgInstalled=`pacman -Qi $1 | grep -o 'Name'`
   echo "$pkgInstalled"
   if [ $pkgInstalled = "Name" ]
   then
       echo "$arpkg is already installed, skipping"
       pkgInstalled="True"
   else
      echo "$arpkg has not been installed, installing"
      pkgInstalled="False"
   fi
   echo "$pkgInstalled"
}
   
CheckInstall $arpkg






