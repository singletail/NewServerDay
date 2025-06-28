# New Server Day!
### t@wse.nyc - 28 June 2025

Notes for configuring a brand-new clean Debian 12 server from no backups.

These are my *personal* methods for setting up a new server from scratch. Many people will surely disagree with portions. That's okay. I didn't make them for you. But I'm happy to share if these help you in any way.

Feel free to drop me a note if you have any questions.

### files

- 01_server.md - basic server setup
- 02_user.md - create and configure first user
- 03_dev_group.md - create a working directory for development
- 04_harden.md - controversial security steps
- 05_dev.md - add a few packages, libraries, proxy, etc.
- 06_misc.md - various additions

### conf files

Destinations for the files in /conf are explained in the various notes files, but for the impatient:

#### .zshrc

```zsh
mv zshrc ~/.zshrc
```

#### sshd_config (note the port change)

```zsh
sudo mv sshd_config /etc/ssh
```

#### iptables

```zsh
sudo mv rules.v4 /etc/iptables/rules.v4
sudo iptables-restore < /etc/iptables/rules.v4
```

#### geofencing scripts - chmod +x

```zsh
sudo mv update_ipset_blacklist.sh /usr/local/sbin/update_ipset_blacklist.sh
sudo mv ipset_restore /etc/network/if-pre-up.d
```

## License

BSD-4-Clause. Deal with it. 🕶️