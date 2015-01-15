#!/bin/bash
# Set these variables to tweak the configuration:
# FISH_CONFIG = http://example.com/config.fish
# VIMRC = http://example.com/vimrc
# GITHUB_NAME = 'John Doe'
# GITHUB_EMAIL = 'johndoe@example.com'

# default locations, if none given.

export green="\e[0;30;42m"
export red="\e[0;30;41m"
export yellow="\e[0;30;43m"
export clear="\e[0m"

shout() {
  echo -e $green "Installed" $@ $clear
}
pout() {
  echo -e $red "Could not install" $@ $clear
}
doubt() {
  echo -e $yellow "Already installed" $@ $clear
}

fish_version() { fish -v; }

install_fish() {
  sudo apt-get update && \
  sudo apt-get -y install fish && \
  fish_version
  if [ $? -ne 0 ]; then
    pout 'fish';
  else
    shout `fish_version`
    install_fish_config
  fi
}

install_fish_config() {
  # default FISH_CONFIG
  : ${FISH_CONFIG:='http://mklbtz.com/files/config.fish'}
  if [[ $FISH_CONFIG == 'http://'* || $FISH_CONFIG == 'https://'* ]]; then
    wget -O ~/.config/fish/config.fish "$FISH_CONFIG"
    shout 'config.fish'
  elif [ -f "$FISH_CONFIG" ]; then
    mv -f "$FISH_CONFIG" ~/.config/fish/config.fish
    shout 'config.fish'
  else
    pout "config.fish ($FISH_CONFIG)"
  fi
}

install_dotfiles() {
  # default VIMRC
  : ${VIMRC:='http://mklbtz.com/files/vimrc'}
  if [[ $VIMRC == 'http://'* || $VIMRC == 'https://'* ]]; then
    wget -O ~/.vimrc "$VIMRC"
    shout '.vimrc'
  elif [ -f "$VIMRC" ]; then
    mv -f "$VIMRC" ~/.vimrc
    shout '.vimrc'
  else
    pout ".vimrc ($VIMRC)"
  fi
}

git_version() { git --version | awk '{print $1,$3}'; }

install_git() {
  sudo apt-get -y install git && \
  git config --global user.name "$GITHUB_NAME" && \
  git config --global user.email "$GITHUB_EMAIL" && \
  git_version
  if [ $? -ne 0 ]; then pout 'git'; else shout `git_version` ; fi
}

docker_version() { docker -v | awk '{print $1,$3}'; }

install_docker() {
  (curl -sSL https://get.docker.com/ubuntu/ | sudo sh) && \
  source /etc/bash_completion.d/docker.io && \
  docker_version
  if [ $? -ne 0 ]; then pout 'docker'; else shout `docker_version`; fi
}

npm_version() { if [ `which npm` ]; then echo "npm $(npm -v;)"; fi; }

install_npm() {
  sudo apt-get -y install npm && npm_version
  if [ $? -ne 0 ]; then pout 'node.js'; else shout npm_version; fi
}

python_version() { python --version; }

install_python() {
  sudo apt-get -y install python && python_version
  if [ $? -ne 0 ]; then pout 'python'; else shout python_version; fi
}

psql_version() { psql --version; }

install_psql() {
  sudo apt-get -y install postgresql libpq-dev && psql_version
  if [ $? -ne 0 ]; then pout 'postgresql'; else shout "psql_version"; fi
}

rvm_version() { rvm --version | awk '{print $1,$2}'; }

install_rvm() {
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3 && \
  (curl -sSL https://get.rvm.io | sudo bash -s stable) && \
  source /etc/profile.d/rvm.sh && \
  rvm_version
  if [ $? -ne 0 ]; then
    pout 'rvm'
  else
    rvm requirements
    shout `rvm_version`
  fi
}

ruby_version() { ruby -v | awk '{print $1,$2}'; }

install_ruby() {
  if [ `which rvm` ]; then
    rvm install ruby && rvm use ruby --default && ruby_version
    if [ $? -ne 0 ]; then pout 'ruby'; else shout `ruby_version`; fi
  fi
}

install_gems() {
  if [ `which ruby` ]; then
    echo "gem: --no-document" >> ~/.gemrc
    rvm rubygems current
    gem install rails bundler foreman
    if [ $? -ne 0 ]; then pout 'gems'; else shout 'gems'; fi
  fi
}

install_all() {
  install_dotfiles
  if [[ -z `which fish` ]]; then install_fish; else doubt `fish_version`; fi
  if [[ -z `which git` ]]; then install_git; else doubt `git_version`; fi
  if [[ -z `which docker` ]]; then install_docker; else doubt `docker_version`; fi
  if [[ -z `which npm` ]]; then install_npm; else doubt `npm_version`; fi
  if [[ -z `which python` ]]; then install_python; else doubt `python_version`; fi
  if [[ -z `which psql` ]]; then install_psql; else doubt `psql_version`; fi
  if [[ -z `which rvm` ]]; then install_rvm; else doubt `rvm_version`; fi
  if [[ -z `which ruby` ]]; then install_ruby; else doubt `ruby_version`; fi
  install_gems
}

install_all
exit 0
