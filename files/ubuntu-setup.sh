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
let successes=0
let errors=0
let warnings=0

shout() {
  echo -e $green "Installed" $@ $clear
  let successes=successes+1
}
pout() {
  echo -e $red "Could not install" $@ $clear
  let errors=errors+1
}
doubt() {
  echo -e $yellow "Already installed" $@ $clear
  let warnings=warnings+1
}

prepend() { cat $1 $2 > "${2}.prepended";  rm $2; mv "${2}.prepended" $2; }

# 1:PROG, 2:VERSION, 3:INSTALLER, 4:SUCCESS, 5:FAIL
# tries to install 1 by running 3, if not already present.
# will run 4 or 5 depending on 3 exit status.
# will show success messages with 2
try_install() {
  : ${2:=`$1 --version`}
  if [[ -z $(which $1) ]]; then
    if [[ $($3) ]]; then
      echo "$($4)"
      shout "$($2)"
    else
      echo "$($5)"
      pout "$($1)"
    fi
  else
    doubt "$($2)"
  fi
}

install_fish() {
  fish_version() { fish -v; }
  get_fish() { sudo apt-get -y install fish; }
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
  try_install 'fish' 'fish_version' 'get_fish' 'install_fish_config'
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

install_git() {
  git_version() { git --version | awk '{print $1,$3}'; }
  get_git() { sudo apt-get -y install git; }
  success() { git config --global user.name "$GITHUB_NAME"; git config --global user.email "$GITHUB_EMAIL"; }
  try_install 'git' 'git_version' 'get_git' 'success'
}

install_docker() {
  docker_version() { docker -v | awk '{print $1,$3}'; }
  get_docker() { curl -sSL https://get.docker.com/ubuntu/ | sudo sh; }
  success() { source /etc/bash_completion.d/docker; }
  try_install 'docker' 'docker_version' 'get_docker' 'success'
}

install_npm() {
  npm_version() { if [ `which npm` ]; then echo "npm $(npm -v;)"; fi; }
  get_npm() { sudo apt-get -y install npm; }
  try_install 'npm' 'npm_version' 'get_npm'
}

install_python() {
  python_version() { python --version; }
  get_python() { sudo apt-get -y install python python-software-properties && python_version; }
  try_install 'python' "python_version" 'get_python'
}

install_psql() {
  psql_version() { psql --version; }
  get_psql() { sudo apt-get -y install postgresql libpq-dev && psql_version; }
  try_install 'psql' 'psql_version' 'get_psql'
}

install_rvm() {
  rvm_version() { rvm --version | awk '{print $1,$2}'; }
  get_rvm() {
    gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3 && \
    (curl -sSL https://get.rvm.io | sudo bash -s stable) && \
    source /etc/profile.d/rvm.sh
  }
  try_install 'rvm' 'rvm_version' 'get_rvm'
}

install_rbenv() {
  rbenv_version() { rbenv -v; }
  rbenv_script() { sudo apt-get install rbenv; }
  bashrc_config() {
    BASHRC_CONFIG='# rbenv config\nexport RBENV_ROOT="${HOME}/.rbenv"\nif [ -d "${RBENV_ROOT}" ]; then\n  export PATH="${RBENV_ROOT}/bin:${PATH}"\n  eval "$(rbenv init -)"\nfi'
    echo -e "$BASHRC_CONFIG" >> ~/.bashrc
    source ~/.bashrc
    echo "XXXXXXXXXXXXXXXX $(which rbenv)"
    rbenv init -
  }
  get_rbenv() {
    rbenv_script && bashrc_config && rbenv bootstrap-ubuntu-12-04
  }
  try_install 'rbenv' 'rbenv_version' 'get_rbenv'
}


install_ruby() {
  ruby_version() { ruby -v | awk '{print $1,$2}'; }
  get_ruby_rvm() { rvm install ruby && rvm use ruby --default && ruby_version; }
  if [ `which rbenv` ]; then
    # PROG='ruby' VERSION='ruby_version' INSTALL='get_ruby_rbenv' try_install
    try_install 'ruby_' 'ruby_version' 'rbenv install 2.1.1' 'rbenv rehash; rbenv global 2.1.1'
  else
    pout 'ruby (no rbenv)'
  fi
}

install_gems() {
  if [ `which ruby` ]; then
    echo "gem: --no-document" >> ~/.gemrc
    gem install bundler rake && rbenv rehash && \
    gem install rails foreman chef fog && rbenv rehash
    if [ $? -ne 0 ]; then pout 'gems'; else shout 'gems'; fi
  else
    pout 'gems (no ruby)'
  fi
}

install_all() {
  sudo apt-get update
  let successes=0
  let errors=0
  let warnings=0
  install_dotfiles
  install_fish
  install_git
  install_docker
  install_npm
  install_python
  install_psql
  install_rbenv
  install_ruby
  install_gems
  echo Done.
  echo -e $green $successes "Installed" $yellow $warnings "Skipped" $red $errors "Failed" $clear
}
