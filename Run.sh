#!/bin/bash
#Written by John Limb Jan 2021
#Creating a simple bash menu to aid use of linux build
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

PS3='Choose your option: '
options=("Join-domain" "Install apps" "Harden Workstation" "Add user to Sudoers" "Quit")
select opt in "${options[@]}"; do
    case $opt in
    "Join-domain")
        echo "Calling Script to Join domain"
        sleep .10
        ./scripts/functions/Join-Domain.sh
        ;;
    "Install apps")
        echo "Calling Script to install applications."
        ./scripts/functions/Install-apps.sh
        sleep .5
        ;;
    "Harden Workstation")
        echo "Calling Scripts to harden Workstation."
        ./scripts/hardening/Harden-appinstall.sh
        ./scripts/hardening/Journal-Config.sh
        ./scripts/hardening/MOTD.sh
        ./scripts/hardening/Restrict-Sudo.sh
        ./scripts/hardening/Password_policy.sh
        ./scripts/hardening/Filesystem_config.sh
        ./scripts/hardening/Enable-ASLR.sh
        #./scripts/hardening/Device-Firewall.sh
        #./scripts/hardening/Network_params.sh
        ./scripts/hardening/ssh_params.sh
        ./scripts/hardening/cron.sh
        ./scripts/hardening/Rsyslog.sh
        ;;
    "Add user to Sudoers")
        echo "calling file to add user to sudoers"
        ./scripts/functions/Add-Sudoer.sh
        ;;
    "Quit")
        echo "Exiting, byee!"
        exit
        ;;
    *) echo -e "${red}invalid option $REPLY" ${reset} ;;
    esac
done
