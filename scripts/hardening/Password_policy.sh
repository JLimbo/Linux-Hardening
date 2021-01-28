#!/bin/bash
#Written by John Limb Jan 2021
#Rational: Strong passwords can help protect a system from attackers.
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

#Install libpam-pwquality
echo "######Install libpam-pwquality######"
apt install libpam-pwquality
#Lets edit password quality file.
PW_QUALITY_CONF=/etc/security/pwquality.conf
Login_Defs=/etc/login.defs
echo "############## Password Policy ##############"


sed -i -r 's/# minlen = 8/minlen = 14/g' $PW_QUALITY_CONF
sed -i -r 's/# dcredit = 0/dcredit = -1/g' $PW_QUALITY_CONF
sed -i -r 's/# ucredit = 0/ucredit = -1/g' $PW_QUALITY_CONF
sed -i -r 's/# ocredit = 0/ocredit = -1/g' $PW_QUALITY_CONF
sed -i -r 's/# lcredit = 0/lcredit = -1/g' $PW_QUALITY_CONF

useradd -D -f 30 # lock accounts that have been inactive for over 30 days

echo "password     required       pam_pwhistory.so remember=5" >> /etc/pam.d/common-password
echo "auth required pam_tally2.so onerr=fail audit silent deny=5 unlock_time=900" >> /etc/pam.d/common-auth

echo "account required pam_tally2.so" >> /etc/pam.d/common-account

echo "###### Setting Password age and umask######"
sed 's/^PASS_MAX_DAYS.*99999/PASS_MAX_DAYS 365/' $Login_Defs
sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS 7/g' $Login_Defs
sed -i 's/^UMASK.*/UMASK 027/g' $Login_Defs