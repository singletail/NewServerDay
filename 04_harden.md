# t@wse.nyc - 28 June 2025

## Danger, Will Robinson!

WARNING: These are extremely controversial measures. Use them cautiously, if at all.

## disable ipv6

nano /etc/default/grub
(add "ipv6.disable=1" to GRUB_CMDLINE_LINUX_DEFAULT and GRUB_CMDLINE_LINUX)
sudo update-grub

nano /etc/sysctl.d/99-disable-ipv6.conf:
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1

nano /etc/network/interfaces - comment out any ipv6 refs
nano /etc/hosts -- comment out ipv6 lines
systemctl mask systemd-networkd-wait-online.service

reboot now
(Run ip -6 addr and ss -6 to verify nothing is listening or configured.)

## ban half the internet

sudo mkdir /etc/ipsets
mv update_ipset_blacklist.sh /usr/local/sbin/update_ipset_blacklist.sh
mv ipset_restore /etc/network/if-pre-up.d

### notes - this:

- Updates script downloads from ipdeny.com into /etc/ipsets/tmp
- Compiles to /etc/ipsets/blacklist.zone, exports to blacklist.save
- Restores script reloads from blacklist.save on boot

### manual additions

/etc/ipsets/custom.zone

### cron (weekly)

> crontab -e
0 3 * * 0 /usr/local/sbin/update_ipset_blacklist.sh >/dev/null 2>&1

### to find ip to unblock, disable rm command and search zone files

grep -l '71.0.0.0/8' /etc/ipsets/tmp/*.zone


