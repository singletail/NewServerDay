# dev - t@wse.nyc - 28 June 2025

## Dependencies

apt-get install make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

## backports

sudo nano /etc/apt/sources.list.d/debian-backports.sources

Types: deb deb-src
URIs: http://deb.debian.org/debian
Suites: bookworm-backports
Components: main
Enabled: yes
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

# python

## pyenv

curl -fsSL https://pyenv.run | bash

### pyenv shell support - add to .zshrc if not already there

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init -)"
export PYTHON_CONFIGURE_OPTS="--enable-optimizations --with-lto"

## build python

export PYENV_DEBUG=1
pyenv install -l

pyenv install -v 3.12.11
pyenv global 3.12.11

### test:

python --version
python -c "import sys; print(sys.executable)"
ldd $(which python)  # Should show linked to libpython

## pip etc.

python -m ensurepip --upgrade
python -m pip install --upgrade pip wheel setuptools

### dev versions in dev dir if desired:

pyenv install -v 3.13.5
cd /var/dev
pyenv local 3.13.5

# go

rm -rf /usr/local/go && tar -C /usr/local -xzf go1.24.4.linux-amd64.tar.gz

## if not using my .zshrc, make sure paths are in your shell

export PATH="$HOME/go/bin:/usr/local/go/bin:$PATH"

# Caddy

sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy

## Caddyfile

usermod -a -G dev caddy
mkdir /var/dev/caddy
mv conf/Caddyfile /var/dev/caddy

### Change systemd service file

sudo nano /lib/systemd/system/caddy.service
(change Caddyfile path)
sudo systemctl daemon-reload
sudo systemctl restart caddy

# To do

## php
## npm