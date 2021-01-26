#Written by John Limb 1/21
#Rational: Disabling the support for filesystems that are not needed will reduce attack surface of machine. 
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

echo "######Removing support for file systems no longer needed######"
cat << EOF >/tmp/dev-sec.conf
install cramfs /bin/true
install freevxfs /bin/true
install jffs2 /bin/true
install hfs /bin/true
install hfsplus /bin/true
install squashfs /bin/true
install udf /bin/true
install vfat /bin/true
EOF

sudo mv /tmp/dev-sec.conf /etc/modprobe.d/


