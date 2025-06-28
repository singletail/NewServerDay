# server - t@wse.nyc - 28 June 2025
# for debian 12

apt-get update
apt-get upgrade
apt-get install linux-generic linux-headers-generic linux-image-generic
apt autoremove

## tz

timedatectl list-timezones
sudo timedatectl set-timezone America/New_York

## hostname

hostnamectl set-hostname example
nano /etc/hosts

1.2.3.4  example.com example
1:2::3:4:5:6  example.com example

## packages

apt install git zsh net-tools build-essential checkinstall zlib1g-dev libssl-dev netfilter-persistent

## ssh

mv conf/sshd_config /etc/ssh/sshd_config

### generate better keys

mkdir /etc/ssh/old
mv /etc/ssh/ssh_host* /etc/ssh/old
ssh-keygen -o -N "" -C "" -t ed25519 -f /etc/ssh/ssh_host_ed25519_key
ssh-keygen -o -N "" -C "" -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key
systemctl restart sshd

(logout, remove entry from home ~/.ssh/knownhosts, relog on new port)

## iptables

sudo mv conf/rules.v4 /etc/iptables/rules.v4
sudo iptables-restore < /etc/iptables/rules.v4
systemctl enable netfilter-persistent
systemctl start netfilter-persistent

## nano /etc/issue

GREETINGS PROFESSOR FALKEN

## nano /etc/motd

WOULD YOU LIKE TO PLAY A GAME?

## passwdless sudo

sudo visudo
%sudo ALL=(ALL) NOPASSWD: ALL

## rsyslog

sudo apt install rsyslog
sudo systemctl enable --now rsyslog

## journald settings

nano /etc/systemd/journald.conf

[Journal]
Storage=persistent
SystemMaxUse=1000M
SystemKeepFree=100M
SystemMaxFileSize=100M
SystemMaxFiles=10
ForwardToSyslog=yes

