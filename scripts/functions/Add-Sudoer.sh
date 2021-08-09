#Written by John Limb 1/21
# Written to allow people to add domain user accounts to sudoers file with ease.
#Setting variables
SUDOERS=/etc/sudoers


echo Enter user to be added to sudoers file
read username
usermod -aG sudo $username
