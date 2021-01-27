#!/usr/bin/env bash
#Written by John L 2/21
#Rational:
#set host network params Applicable for servers and workstations!
set -euf -o pipefail

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

echo "############## Disable source routed packets ##############"

echo "net.ipv4.conf.all.accept_source_route = 0" >>/etc/sysctl.conf
echo "net.ipv4.conf.default.accept_source_route = 0" >>/etc/sysctl.conf
echo "net.ipv6.conf.all.accept_source_route = 0" >>/etc/sysctl.conf
echo "net.ipv6.conf.default.accept_source_route = 0" >>/etc/sysctl.conf

sysctl -w net.ipv4.conf.all.accept_source_route=0
sysctl -w net.ipv4.conf.default.accept_source_route=0
sysctl -w net.ipv6.conf.all.accept_source_route=0
sysctl -w net.ipv6.conf.default.accept_source_route=0
sysctl -w net.ipv4.route.flush=1
sysctl -w net.ipv6.route.flush=1

echo "##############  Don't accept ICMP redirects ##############"

echo "net.ipv4.conf.all.accept_redirects = 0" >>/etc/sysctl.conf
echo "net.ipv4.conf.default.accept_redirects = 0" >>/etc/sysctl.conf
echo "net.ipv6.conf.all.accept_redirects = 0" >>/etc/sysctl.conf
echo "net.ipv6.conf.default.accept_redirects = 0" >>/etc/sysctl.conf

sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.default.accept_redirects=0
sysctl -w net.ipv6.conf.all.accept_redirects=0
sysctl -w net.ipv6.conf.default.accept_redirects=0
sysctl -w net.ipv4.route.flush=1
sysctl -w net.ipv6.route.flush=1

sysctl -w net.ipv4.conf.all.send_redirects=0
sysctl -w net.ipv4.conf.default.send_redirects=0
sysctl -w net.ipv4.route.flush=1

echo "##############  Don't accept secure ICMP redirects ##############"

echo "net.ipv4.conf.all.secure_redirects = 0" >>/etc/sysctl.conf
echo "net.ipv4.conf.default.secure_redirects = 0" >>/etc/sysctl.conf

sysctl -w net.ipv4.conf.all.secure_redirects=0
sysctl -w net.ipv4.conf.default.secure_redirects=0
sysctl -w net.ipv4.route.flush=1

echo "############## Log suspicious packets ##############"

echo "net.ipv4.conf.all.log_martians = 1" >>/etc/sysctl.conf
echo "net.ipv4.conf.default.log_martians = 1" >>/etc/sysctl.conf

sysctl -w net.ipv4.conf.all.log_martians=1
sysctl -w net.ipv4.conf.default.log_martians=1
sysctl -w net.ipv4.route.flush=1

echo "############## Ignore ICMP broadcast requests ##############"

echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >>/etc/sysctl.conf

sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
sysctl -w net.ipv4.route.flush=1

echo "############## Ignore bogus ICMP responses ##############"

echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" >>/etc/sysctl.conf

sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
sysctl -w net.ipv4.route.flush=1

echo "############## Enable Reverse Path filtering ##############"

echo "net.ipv4.conf.all.rp_filter = 1" >>/etc/sysctl.conf
echo "net.ipv4.conf.default.rp_filter = 1" >>/etc/sysctl.conf

sysctl -w net.ipv4.conf.all.rp_filter=1
sysctl -w net.ipv4.conf.default.rp_filter=1
sysctl -w net.ipv4.route.flush=1

echo "############## Enable TCP Syn Cookies ##############"

echo "net.ipv4.tcp_syncookies = 1" >>/etc/sysctl.conf

sysctl -w net.ipv4.tcp_syncookies=1
sysctl -w net.ipv4.route.flush=1

echo "############## Don't accept IPv6 router advertisments ##############"

echo "net.ipv6.conf.all.accept_ra = 0" >>/etc/sysctl.conf
echo "net.ipv6.conf.default.accept_ra = 0" >>/etc/sysctl.conf

sysctl -w net.ipv6.conf.all.accept_ra=0
sysctl -w net.ipv6.conf.default.accept_ra=0
sysctl -w net.ipv6.route.flush=1
