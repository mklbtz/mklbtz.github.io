#!/bin/bash
# Set these variables to tweak the configuration:
# FISH_CONFIG = http://example.com/config.fish
# VIMRC = http://example.com/vimrc
# GITHUB_NAME = 'John Doe'
# GITHUB_EMAIL = 'johndoe@example.com'

export green="\e[0;30;42m"
export red="\e[0;30;41m"
export clear="\e[0m"
alias shout='_shout(){ echo -e $green "Installed $1" $clear; }; _shout'
alias pout='_pout(){ echo -e $red "Could not install $1" $clear; }; _pout'

# default locations, if none given.
: ${FISH_CONFIG:='http://mklbtz.com/files/config.fish'}
: ${VIMRC:='http://mklbtz.com/files/vimrc'}

# install fish shell
sudo apt-get update && \
sudo apt-get -y install fish
if [ $? -ne 0 ]; then pout 'fish'; else shout "$(fish -v)"; fi
if [ -z "$FISH_CONFIG" ]; then
  wget "$FISH_CONFIG" -O ~/.config/fish/config.fish
  shout 'config.fish'
elif [ -f './config.fish' ]; then
  mv -f ./config.fish ~/.config/fish/config.fish
  shout 'config.fish'
fi
if [ -z "$VIMRC" ]; then
  wget "$VIMRC" -O ~/.vimrc
  shout '.vimrc'
elif [ -f '.vimrc' ]; then
  mv -f .vimrc ~/.vimrc
  shout '.vimrc'
fi

# install git
sudo apt-get -y install git && \
git config --global user.name "$GITHUB_NAME" && \
git config --global user.email "$GITHUB_EMAIL"
if [ $? -ne 0 ]; then pout 'git'; else shout "$(git --version | awk '{print $1,$3}')"; fi

# install docker
curl -sSL https://get.docker.com/ubuntu/ | sudo sh
source /etc/bash_completion.d/docker.io
if [ $? -ne 0 ]; then pout 'docker'; else shout "$(docker -v | awk '{print $1,$3}')"; fi

# install rvm
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \
(curl -L https://get.rvm.io | bash -s stable) && \
rvm requirements
if [ $? -ne 0 ]; then pout 'rvm'; else source ~/.rvm/scripts/rvm; shout "$(rvm --version | awk '{print $1,$2}')"; fi

# install ruby
rvm install ruby && rvm use ruby --default
if [ $? -ne 0 ]; then pout 'docker'; else shout "$(ruby -v | awk '{print $1,$2}')"; fi

# install rails, bundler
echo "gem: --no-document" >> ~/.gemrc
rvm rubygems current && gem install rails bundler
if [ $? -ne 0 ]; then pout 'docker'; else shout "$(echo `rails -v`, `bundle -v | awk '{print $1,$3}'`)"; fi

# install node.js
sudo apt-get -y install npm
if [ $? -ne 0 ]; then pout 'node.js'; else exclaim "npm $(npm -v)"; fi

#install postgres
sudo apt-get -y install postgresql libpq-dev
if [ $? -ne 0 ]; then pout 'postgresql'; else exclaim "psql --version"; fi
