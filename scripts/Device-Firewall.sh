#Written by John Limb 1/21
#Rational: We want to operate on the basis that only established / related traffic is allowed unless a service otherwise reqires it. We want ping an SSH allowed for mgmt
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
echo "######## 1.1 - Configure IP table rules - ########"
sleep .5

#Start by IP Tables - Going on the rule no inbound bar SSH and ping
#disable UFW
ufw disable
echo "######Install ip tables######"
apt install iptables iptables-persistent
echo "######Flushing current ruleset######"
iptables -F
echo "######Ensuring Default drop######"
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
echo "######Ensure loopback policy is configured######"
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT -s 127.0.0.0/8 -j DROP
echo "######Ensure outbound/established/related connections are good to go######"
iptables -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p udp -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p udp -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -m state --state ESTABLISHED -j ACCEPT
echo "######Open inbound ssh(tcp port 22) connections and ping######"
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT
echo "######Save v4 Firewall rules######"
iptables-save >/etc/iptables/rules.v4
echo "######Run the same for IPV6######"
echo "######Flush IP6tables rules######"
ip6tables -F
echo "######Ensure default deny firewall policy######"
ip6tables -P INPUT DROP
ip6tables -P OUTPUT DROP
ip6tables -P FORWARD DROP

ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A OUTPUT -o lo -j ACCEPT
ip6tables -A INPUT -s ::1 -j DROP
#Save
ip6tables-save >/etc/iptables/rules.v6
echo "######## 1.1 - Configure IP table rules Complete - ########"
sleep .5
