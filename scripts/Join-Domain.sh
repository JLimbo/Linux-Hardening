#!/bin/bash

#Written by John Limb - 19/7/2019.
#Aim is to install relivent applications and packages.. And perform configuration. We might never get that far but we will see.
#setting variables
lightdm=/usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
set -eo pipefail
#Checking if you are root.. if not then you will get error
echo Checking that you are root...
#sleeping
sleep .5
if [[ $(id -u) -ne 0 ]]; then
    echo "UH OH! you are not root! Please run me as root!"
    exit 1
fi

#define admin running script
echo Enter Domain Admin username
read username
echo -e hello $username - Welcome to the Linux build script. Please follow any onscreen instructions given.
sleep .10
#checking for update
echo checking updates
sudo apt-get update
sudo apt-get upgrade -y

#channging to root of disk
echo changing to /
sleep .5
cd /

#making temp dir
echo making temp folder, when prompted enter folder name
echo "Enter directory name E.G Temp"
read dirname

if [ ! -d "$dirname" ]; then
    echo "File doesn't exist. Creating now"
    mkdir /$dirname
    echo "File created"
else
    echo "File exists"
fi

#changing to new dir
echo changing to new dir
cd ./$dirname
echo sleeping
sleep .5
#Time for apps
echo Time to install some applications
while read -r p; do sudo apt-get install -y $p; done < <(
    cat <<"EOF"
unzip
    realmd
    libnss-sss
    libpam-sss
    sssd
    sssd-tools
    adcli
    samba-common-bin
    oddjob
    oddjob-mkhomedir
    packagekit
    ntpdate     
EOF
)
#set hostname
echo "Enter machine hostname example:UK04-Lxxxyyy123"
read hostname
echo -e $hostnmame is now hostname - setting
sleep .10
sudo hostnamectl set-hostname $hostname

# Set domain
while true; do
    read -erp "Please enter your domain name in all caps FQDN!: "
    # regex get from http://myregexp.com/examples.html
    if [[ $REPLY =~ ^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$ ]]; then
        DOMAIN=${REPLY^^}
        WORKGROUP=$(echo $DOMAIN | sed 's/\..*//')
        SERVER=${DOMAIN,,}
        break
    else
        echo "Wrong domain format ($REPLY), please try again!"
        #exit
    fi
done

#Discover domain
echo discovering $DOMAIN
sleep .5
sudo realm discover $DOMAIN

#setting date and time sources.
echo setting Date and Time sources. please wait.
sleep .5
sudo ntpdate -q $DOMAIN
sudo ntpdate $DOMAIN

#Join the domain
echo joining domain
sudo realm join -U $username $DOMAIN
echo sleeping 30seconds
sleep .30

#list domain
echo listing DOMAIN
realm list

#Enabling creation of homedir
cat <<EOF >>/usr/share/pam-configs/mkhomedir
Name: activate mkhomedir
Default: yes
Priority: 900
Session-Type: Additional
Session:
        required                        pam_mkhomedir.so umask=0022 skel=/etc/skel
EOF

#activate home file creation
sudo pam-auth-update

#restart stuff
systemctl restart sssd

#edit lightdm
echo "greeter-show-manual-login=true" >>$lightdm
echo "greeter-hide-users=true" >>$lightdm

#cleaning up
echo cleaning up!
sleep 2
rm -rf /$dirname

echo Complete! please reboot this machine and login as the user.
echo hit CTRL+C to end
echo -e "\n"
sleep 20
