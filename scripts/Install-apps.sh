#Written by John Limb - 1/21
#setting variable to auto exit on error
set -eo pipefail
#Checking if you are root.. if not then you will get error
echo Checking that you are root...
#sleeping
sleep .5
if [[ $(id -u) -ne 0 ]]; then
    echo "UH OH! you are not root! Please run me as root!"
    exit 1
fi

#checking for update
echo checking updates
sudo apt-get update
sudo apt-get upgrade -y

#changing to root of disk
echo changing to /
sleep .5
cd /

#Fetching Chrome
echo fetching chrome!
sleep .5
sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#installing chrome
echo installing Chrome!
sudo apt install ./google-chrome*.deb

#fetching zoom
echo fetching zoom!!
sleep .5
sudo wget https://zoom.us/client/latest/zoom_amd64.deb
sudo dpkg -i ./zoom_amd64.deb

#fetching slack
echo installing ye old slack
sleep .5
sudo snap install slack --classic
