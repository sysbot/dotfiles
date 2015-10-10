Collection of dotfiles.
# PreInstallation

Setup Homebrew for MACOSX or Linux.
```
./pre_install
```

# Setup

## Get this repo
```
git clone --recursive git@github.com:sysbot/dotfiles.git
```

## Full installation
```
bash ./dotfiles/install full
```

## Default just minimal
```
bash ./dotfiles/install
```

## Uninstall
```
bash ./dotfiles/install clean
```

# Usage

## Update all the submodules in dotfiles
```
git submodule foreach git pull origin master
```

## Encryption stuff

Get `$HOME/.gnupg` setup and `brew install git-crypt`.

Follow `gpg_install` to setup GPG key for the first time.

Checkout all the necessary git-crypt repos such as `ssh`.

## Misc

Make sure to setup VIM by installing the plugins and rebuild YCM.

```
rebuild_youcompleteme.sh
```

# Post Install 

Setup `teamocil`
```
./post_install
```
