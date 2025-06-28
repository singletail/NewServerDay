# user - t@wse.nyc - 28 June 2025

/usr/sbin/adduser username
usermod -aG sudo username

## keys

mkdir /home/username/.ssh
chown username:username /home/username/.ssh
chmod 700 /home/username/.ssh
touch /home/username/.ssh/authorized_keys
chown username:username /home/username/.ssh/authorized_keys
chmod 600 /home/username/.ssh/authorized_keys

### install key (from home machine)

ssh-copy-id -i ~/.ssh/id_ed25519 username@example.com

## zsh

mv conf/zshrc /home/username/.zshrc
chsh username /usr/bin/zsh
(relog with key)

## git

git config --global user.name "username"
git config --global user.email "username@example.com"
git config --global init.defaultBranch master
git config --global color.ui auto
git config --global core.editor nano

### nano ~/.ssh/config

host github.com
    HostName github.com
    User git
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/id_ed25519
