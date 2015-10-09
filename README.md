Collection of dotfiles.

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

Checkout all the necessary git-crypt repos such as `ssh`.
