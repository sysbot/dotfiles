#!/bin/bash

# Setup home!

# setup zsh and presto
git clone --recursive git@github.com:sysbot/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

# setup vim
git clone --recursive git@github.com:sysbot/dotvim "$HOME/.vim"
FILES=(vimrc)
for i in $FILES; do
  ln -s "$HOME/.vim/$i" "$HOME/.$i"
done

# setup weechat
git clone --recursive git@github.com:sysbot/dotweechat "$HOME/.weechat"

# setup mutt
git clone --recursive git@github.com:sysbot/dotmutt "$HOME/.mutt"
FILES=(goobookrc.fastly mailcap msmtprc muttrc offlineimaprc goobookrc urlview)
for i in $FILES; do
  ln -s "$HOME/.mutt/$i" "$HOME/.$i"
done

# setup ssh
git clone --recursive $BACKUPDRIVE/personal/dotssh "$HOME/.ssh"

# setup gpg
./gpg-setup.sh

# setup chef
git clone --recursive git@github.com:fastly/bao-dotchef.git "$HOME/.chef"

# setup tmux
ln -s $HOME/dotfiles/tmux.osx.conf $HOME/.tmux.conf

# setup git and development enviroment
ln -s $HOME/dotfiles/gitconfig $HOME/.gitconfig
ln -s $HOME/dotfiles/rspec $HOME/.rspec
