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

#making temp dir
echo making temp folder, when prompted enter folder name
echo "Enter directory name E.G Temp"
read dirname

if [ ! -d "$dirname" ]; then
    echo "File doesn't exist. Creating now"
    cd /
    mkdir $dirname
    echo "File created"
else
    echo "File exists"
fi

#changing to new directory 
echo changing to /$dirname
sleep .5
cd /$dirname

#Fetching Chrome
echo fetching chrome!
sleep .5
sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#installing chrome
echo installing Chrome
sudo apt install ./google-chrome*.deb

#fetching zoom
echo fetching zoom
sleep .5
sudo apt update
sudo apt install snapd
sudo snap install zoom-client

#fetching slack
echo installing slack
sleep .5
sudo snap install slack --classic


#cleanup after
echo cleaning up!
sleep 2
rm -rf /$dirname

echo Complete! please reboot this machine and login as the user.
echo hit CTRL+C to end
echo -e "\n"
sleep 20
