# misc - t@wse.nyc - 28 June 2025

## Cockpit

bash -i
sudo apt-get install -t bookworm-backports cockpit
sudo systemctl enable --now cockpit.socket

(open port in iptables or reverse proxy via caddy)

## DNS - MAYBE Unbound. Not currently using.

apt install unbound
nano /etc/unbound/unbound.conf.d/local.conf:

server:
  interface: 127.0.0.1
  access-control: 127.0.0.0/8 allow
  hide-identity: yes
  hide-version: yes
  prefetch: yes
  cache-min-ttl: 360
  cache-max-ttl: 86400
  do-ip6: no

nano /etc/resolv.conf
(point to 127.0.0.1)

