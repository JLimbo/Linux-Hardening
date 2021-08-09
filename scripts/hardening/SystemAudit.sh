#Written by John Limb 1/21
#Rational: Setting auditing policies on system.
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
echo "-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale" | sudo tee -a /etc/audit/audit.rules
echo "-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale" | sudo tee -a /etc/audit/audit.rules
echo "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change" | sudo tee -a /etc/audit/audit.rules
echo "-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change" | sudo tee -a /etc/audit/audit.rules
echo "-a always,exit -F arch=b64 -S clock_settime -k time-change" | sudo tee -a /etc/audit/audit.rules
echo "-a always,exit -F arch=b32 -S clock_settime -k time-change" | sudo tee -a /etc/audit/audit.rules
echo "-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod" | sudo tee -a /etc/audit/audit.rules
echo "-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod" | sudo tee -a /etc/audit/audit.rules
echo "-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod" | sudo tee -a /etc/audit/audit.rules
echo "-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod" | sudo tee -a /etc/audit/audit.rules
echo "-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" | sudo tee -a /etc/audit/audit.rules
echo "-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" | sudo tee -a /etc/audit/audit.rules
echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access" | sudo tee -a /etc/audit/audit.rules
echo "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access" | sudo tee -a /etc/audit/audit.rules
echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access" | sudo tee -a /etc/audit/audit.rules
echo "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access" | sudo tee -a /etc/audit/audit.rules
echo "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" | sudo tee -a /etc/audit/audit.rules
echo "-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" | sudo tee -a /etc/audit/audit.rules
echo "-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" | sudo tee -a /etc/audit/audit.rules
echo "-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" | sudo tee -a /etc/audit/audit.rules
echo "-a always,exit arch=b64 -S init_module -S delete_module -k modules" | sudo tee -a /etc/audit/audit.rules
echo "-w /etc/localtime -p wa -k time-change" | sudo tee -a /etc/audit/audit.rules
echo "-w /etc/group -p wa -k identity" | sudo tee -a /etc/audit/audit.rules
echo "-w /etc/passwd -p wa -k identity" | sudo tee -a /etc/audit/audit.rules
echo "-w /etc/gshadow -p wa -k identity" | sudo tee -a /etc/audit/audit.rules
echo "-w /etc/shadow -p wa -k identity" | sudo tee -a /etc/audit/audit.rules
echo "-w /etc/security/opasswd -p wa -k identity" | sudo tee -a /etc/audit/audit.rules
echo "-w /etc/issue -p wa -k system-locale" | sudo tee -a /etc/audit/audit.rules
echo "-w /etc/issue.net -p wa -k system-locale" | sudo tee -a /etc/audit/audit.rules
echo "-w /etc/hosts -p wa -k system-locale" | sudo tee -a /etc/audit/audit.rules
echo "-w /etc/network -p wa -k system-locale" | sudo tee -a /etc/audit/audit.rules
echo "-w /etc/networks -p wa -k system-locale" | sudo tee -a /etc/audit/audit.rules
echo "-w /etc/sudoers -p wa -k scope-w /etc/sudoers.d -p wa -k scope" | sudo tee -a /etc/audit/audit.rules
echo "-w /var/log/sudo.log -p wa -k actions" | sudo tee -a /etc/audit/audit.rules
echo "-w /var/log/faillog -p wa -k logins" | sudo tee -a /etc/audit/audit.rules
echo "-w /var/log/lastlog -p wa -k logins" | sudo tee -a /etc/audit/audit.rules
echo "-w /var/log/tallylog -p wa -k logins" | sudo tee -a /etc/audit/audit.rules
echo "-w /var/run/utmp -p wa -k session" | sudo tee -a /etc/audit/audit.rules
echo "-w /var/log/wtmp -p wa -k session" | sudo tee -a /etc/audit/audit.rules
echo "-w /var/log/btmp -p wa -k session" | sudo tee -a /etc/audit/audit.rules
echo "-w /sbin/insmod -p x -k modules" | sudo tee -a /etc/audit/audit.rules
echo "-w /sbin/rmmod -p x -k modules" | sudo tee -a /etc/audit/audit.rules
echo "-w /sbin/modprobe -p x -k modules" | sudo tee -a /etc/audit/audit.rules
echo "-w /sbin/insmod -p x -k modules-w /sbin/rmmod -p x -k modules-w /sbin/modprobe -p x -k modules-a always,exit arch=b64 -S init_module -S delete_module -k modules" | sudo tee -a /etc/audit/audit.rules
echo "-w /etc/sudoers -p wa -k scope-w /etc/sudoers.d/ -p wa -k scope" | sudo tee -a /etc/audit/audit.rules
echo "-w /var/run/utmp -p wa -k session-w /var/log/wtmp -p wa -k logins-w /var/log/btmp -p wa -k logins" | sudo tee -a /etc/audit/audit.rules
echo "-e 2" | sudo tee -a /etc/audit/audit.rules