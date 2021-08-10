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

echo "######Creating login banner and motd######"
#Update login banners
echo "printf \"\n"\" | sudo tee -a /etc/update-motd.d/00-header
echo "printf \"AUTHORIZED ACCESS ONLY - Unauthorized access is strictly forbidden.\n"\" | sudo tee -a /etc/update-motd.d/00-header
echo "printf \"\\-----------------------------------------\n"\" | sudo tee -a /etc/update-motd.d/00-header
echo "printf \"Your session has been logged\n"\" | sudo tee -a /etc/update-motd.d/00-header
echo "printf \"\n"\" | sudo tee -a /etc/update-motd.d/00-header
sudo touch /etc/motd
sudo chmod 644 /etc/motd
#sudo mv /etc/update-motd.d/10-help-text /var/tmp/
echo "All connections are monitored and recorded" | sudo tee /etc/issue.net
echo "Disconnect immediately if you are not authorized user" | sudo tee -a /etc/issue.net
echo "All connections are monitored and recorded" | sudo tee /etc/issue
echo "Disconnect immediately if you are not authorized user" | sudo tee -a /etc/issue

echo "######Setting Root password######"
echo enter root password
read -s password
passwd root << EOD
${password}
${password}
EOD