#!/bin/bash
#Written by John Limb Jan 2021
#Rational: Restricting su - sudo is better and has better loggin mechanisms in place when using privlage escalation. 
##---------------------------
#Set colour variables
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)
#setting variable to auto exit on error
set -eo pipefail
#Checking if you are root.. if not then you will get error
echo Checking that you are root...
#sleeping
sleep .5
if [[ $(id -u) -ne 0 ]]; then
    echo -e "${red}UH OH! you are not root! Please run me as root!"${reset}
    exit 1
fi

echo "######Create Sudo Logfile and pty######"
echo "Defaults logfile="/var/log/sudo.log"">>/etc/sudoers
echo "Defaults use_pty">>/etc/sudoers

echo "###### Restiric su ######"

groupadd sugroup

echo "auth required pam_wheel.so use_uid group=sugroup" >> /etc/pam.d/su