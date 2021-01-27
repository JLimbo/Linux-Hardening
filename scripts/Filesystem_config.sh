#Written by John Limb 1/21
#Rational: Disabling the support for filesystems that are not needed will reduce attack surface of machine. Also securing folders to make adjustments harder. 
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

echo "######Configuring Filesystem permissions######"
#/etc/passwd
chown root:root /etc/passwd
chmod 644 /etc/passwd
#/etc/gshadow
chown root:root /etc/gshadow-
chown root:shadow /etc/gshadow-
chmod o-rwx,g-wx /etc/gshadow-
#/etc/shadow
chown root:root /etc/shadow
chown root:shadow /etc/shadow
chmod o-rwx,g-wx /etc/shadow
#/etc/group
chown root:root /etc/group
chmod u-x,go-wx /etc/group
#/etc/passwd-
chown root:root /etc/passwd-
chmod u-x,go-wx /etc/passwd-
#/etc/shadow-
chown root:shadow /etc/shadow-
chmod u-x,g-wx,o-rwx /etc/shadow-
#/etc/group-
chown root:root /etc/group-
chmod u-x,go-wx /etc/group-
#/etc/gshadow
chown root:root /etc/gshadow
chown root:shadow /etc/gshadow
chmod u-x,g-wx,o-rwx /etc/gshadow
#
echo "######looking at home directory permissions######"
cat /etc/passwd | egrep -v '^(root|halt|sync|shutdown)' | awk -F: '($7 != "/usr/sbin/nologin" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do
  if [ ! -d "$dir" ]; then
    echo "The home directory ($dir) of user $user does not exist."
  else
    dirperm=`ls -ld $dir | cut -f1 -d" "`
    if [ `echo $dirperm | cut -c6` != "-" ]; then
      echo "Group Write permission set on the home directory ($dir) of user $user"
    fi
    if [ `echo $dirperm | cut -c8` != "-" ]; then
      echo "Other Read permission set on the home directory ($dir) of user $user"
    fi
    if [ `echo $dirperm | cut -c9` != "-" ]; then
      echo "Other Write permission set on the home directory ($dir) of user $user"
    fi
    if [ `echo $dirperm | cut -c10` != "-" ]; then
      echo "Other Execute permission set on the home directory ($dir) of user $user"
    fi
  fi
done
#

#Grub
echo "######Securing Grub permissions######"
chown root:root /boot/grub/grub.cfg
chmod og-rwx /boot/grub/grub.cfg

echo "######Configuring /tmp######"
cp -v /usr/share/systemd/tmp.mount /etc/systemd/system/
systemctl daemon-reload
systemctl --now enable tmp.mount

echo "######Correcting options on /dev/shm and /tmp######"
echo "tmpfs /dev/shm tmpfs defaults,nodev,nosuid,noexec 0 0" >> /etc/fstab
echo "tmpfs /tmp tmpfs rw,noexec,nodev,nosuid,size=2G 0 0" >> /etc/fstab
mount -o remount,nodev,noexec /dev/shm
mount -o nodev,noexec /tmp