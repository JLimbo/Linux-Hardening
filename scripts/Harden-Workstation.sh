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

# Next up we configure Journald
echo "######## Configure Journald - ########"
sed -i -r 's/#ForwardToSyslog=yes/ForwardToSyslog=yes/g' /etc/systemd/journald.conf
sed -i -r 's/#Compress=yes/Compress=yes/g' /etc/systemd/journald.conf
sed -i -r 's/#Storage=auto/Storage=persistent/g' /etc/systemd/journald.conf

#Log file permissions
echo "############## 1.3 Fix permissions on logfiles ##############"
find /var/log -type f -exec chmod g-wx,o-rwx {} +

echo "######Creating login banner and motd######"
#Update login banners
echo "printf \"\n"\" | sudo tee -a /etc/update-motd.d/00-header
echo "printf \"AUTHORIZED ACCESS ONLY - Unauthorized access is strictly forbidden.\n"\" | sudo tee -a /etc/update-motd.d/00-header
echo "printf \"\\-----------------------------------------\n"\" | sudo tee -a /etc/update-motd.d/00-header
echo "printf \"Your session has been logged\n"\" | sudo tee -a /etc/update-motd.d/00-header
echo "printf \"\n"\" | sudo tee -a /etc/update-motd.d/00-header
sudo touch /etc/motd
sudo chmod 644 /etc/motd
sudo mv /etc/update-motd.d/10-help-text /var/tmp/
echo "All connections are monitored and recorded" | sudo tee /etc/issue.net
echo "Disconnect immediately if you are not authorized user" | sudo tee -a /etc/issue.net
echo "All connections are monitored and recorded" | sudo tee /etc/issue
echo "Disconnect immediately if you are not authorized user" | sudo tee -a /etc/issue

echo "######Create Sudo Logfile and pty######"
echo "Defaults logfile="/var/log/sudo.log"">>/etc/sudoers
echo "Defaults use_pty">>/etc/sudoers

echo "######Install AIDE######"
apt install aide aide-common -y
aideinit
mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db

echo "######Setting Root password######"
echo enter root password
read password
passwd root << EOD
${password}
${password}
EOD