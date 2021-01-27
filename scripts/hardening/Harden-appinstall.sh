#Harden-Workstation.sh
#Written by John Limb 1/21
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
echo "######Upgrade VIM and purge non required packages######"
sudo add-apt-repository ppa:jonathonf/vim -y
sudo apt update
sudo apt install vim -y
#purge prelink program that modifies ELF shared libraries and ELF dynamically linked binaries in such a way that the time needed for the dynamic linker to perform relocations at startup significantly decreases.
sudo apt purge prelink
sudo apt-get purge telnet rsync -y

echo "######Install AIDE######"
apt install aide aide-common -y
aideinit
mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db