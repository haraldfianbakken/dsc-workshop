#!/bin/bash

if [$# -lt 2]; 
    then echo "Invalid usage - Use $0 <key> <url>"
fi

# DSC Variables
DSCKEY=$1   #"DSC access key"
DSCURL=$2   #"DSC URL

###########################################################
# Download and install OMI
# The script will use the OMI package in the OMS package
###########################################################
wget https://github.com/Microsoft/OMS-Agent-for-Linux/releases/download/v1.1.0-28/omsagent-1.1.0-28.universal.x64.sh
chmod 755 omsagent-1.1.0-28.universal.x64.sh
./omsagent-1.1.0-28.universal.x64.sh --extract
chmod 755 ./omsbundle* -R
mv ./omsbundle* ./omsbundle
dpkg -i ./omsbundle/100/omi-1.0.8-4.universal.x64.deb

###########################################################
# Download and install DSC
###########################################################
wget https://github.com/Microsoft/PowerShell-DSC-for-Linux/releases/download/v1.1.1-70/dsc-1.1.1.packages.tar.gz
chmod 755 dsc-1.1.1.packages.tar.gz

mkdir DSC
tar -xvf dsc-1.1.1.packages.tar.gz -C DSC
chmod 755 DSC -R

dpkg -i ./DSC/dsc-1.1.1-70.ssl_100.x64.deb

/opt/microsoft/dsc/Scripts/Register.py $DSCKEY $DSCURL