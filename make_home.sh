#!/bin/bash

# config script

# check distro and architecture and set variables
echo 'Starting script'

CYGWIN=`uname | grep -o 'CYGWIN'`

echo "$CYGWIN is the env"
