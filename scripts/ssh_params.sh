#!/usr/bin/env bash
#Written by John L 2/21
#Rational: We want to secure the SSHD Config file and pub/priv keys to prevent changes by non-privileged users. This is to help prevent compromise on SSH
#set host SSH params Applicable for servers and workstations!
set -euf -o pipefail

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi
#Variables
SSH_CONF=/etc/ssh/sshd_config
sudo apt install openssh-server -y
#Start
echo "######Setting permissions on SSHD Config file######"
chown root:root /etc/ssh/sshd_config
chmod og-rwx /etc/ssh/sshd_config
#
echo "######Setting permissions SSH Private key files######"
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' | xargs chown root:root
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' | xargs chmod 0600
#
echo "######Setting permissions on SSH public key files######"
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' | xargs chmod go-wx
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' | xargs chown root:root
#
echo "######Setting log level and other args######"
echo "Protocol 2" >>$SSH_CONF

sed -i -r 's/#LogLevel INFO/LogLevel INFO/g' $SSH_CONF
sed -i -r 's/#MaxAuthTries 6/MaxAuthTries 3/g' $SSH_CONF
sed -i -r 's/#IgnoreRhosts yes/IgnoreRhosts yes/g' $SSH_CONF
sed -i -r 's/#HostbasedAuthentication no/HostbasedAuthentication no/g' $SSH_CONF
sed -i -r 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' $SSH_CONF
sed -i -r 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/g' $SSH_CONF
sed -i -r 's/#PermitUserEnvironment no/PermitUserEnvironment no/g' $SSH_CONF
sed -i -r 's/X11Forwarding yes/X11Forwarding no/g' $SSH_CONF
sed -i -r 's/#Banner none/Banner \/etc\/issue.net/g' $SSH_CONF
#
echo "######Setting SSH Supported cyphers and Key algorythms /Exchanges ######"

echo "Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr" >>$SSH_CONF
echo "MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256" >>$SSH_CONF

KEYALG1="KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,"
KEYALG2="diffie-hellman-group14-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,"
KEYALG3="ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256"

echo $KEYALG1$KEYALG2$KEYALG3 >>$SSH_CONF
#
echo "###### Setting Client alive time and gracetime"

sed -i -r 's/#ClientAliveInterval 0/ClientAliveInterval 300/g' $SSH_CONF
echo "ClientAliveCountMax 3" >>$SSH_CONF
sed -i -r 's/#LoginGraceTime 2m/LoginGraceTime 60/g' $SSH_CONF
#
echo "###### Setting SSH authorised users ######"
echo "AllowUsers AllMightyOne" >>$SSH_CONF
#
