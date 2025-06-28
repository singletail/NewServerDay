# dev group - t@wse.nyc - 28 June 2025

groupadd -g 666 -r dev
useradd -b /dev/null -g 666 -M -N -r -u 666 dev
usermod -a -G dev username

# dev directory - put it somewhere you like - this is not standard

mkdir /var/dev
chown dev:dev /var/dev
chmod g+s /var/dev

# add to /etc/profile, /etc/zsh/zprofile, or .zshrc

umask 002
