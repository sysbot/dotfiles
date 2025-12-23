# Dotfiles Makefile
# Updated: December 2025
#
# Usage:
#   make base   - Minimal installation
#   make full   - Full installation
#   make config - Install XDG config apps (ghostty, kitty, zed)
#   make doctor - Health check for dotfiles

home = $(HOME)
dotdir = $(home)/dotfiles
GNUPGHOME ?= /Volumes/keys/gnupg
SSHHOME ?= /Volumes/keys/ssh
KEY = 'E62E145F60DED6F4D0E49CF2E2DD7EEB82B4A8AC'

# Config files to symlink as ~/.<name> from dotfiles/dot<name>
more = dnsmasq.conf ansiweatherrc mbsyncrc msmtprc rclone.conf tmux.conf air.conf ticker.yaml

# Development configs
dev = gitconfig tigrc

# Private/encrypted directories
privs = ssh sec aws gcloud password-store

# Prezto shell files
prezto = zlogout zlogin zprofile zshrc zpreztorc zshenv

# XDG config directories
xdg_configs = hub pet

# New XDG config apps
xdg_apps = ghostty kitty zed

# =============================================================================
# Main targets
# =============================================================================

.PHONY: base full config doctor clean help

## Minimal installation
base: brewbase dotfiles $(prezto) $(dev)
	@echo "Base installation complete"

## Full installation
full: brewfile base $(more) $(privs) $(xdg_configs) config virtualenv dnsmasq
	@echo "Full installation complete"

## Install XDG config apps (ghostty, kitty, zed)
config: config_dir $(xdg_apps)
	@echo "Config apps installed"

## Health check for dotfiles
doctor:
	@echo "=== Dotfiles Health Check ==="
	@echo ""
	@echo "Checking submodules..."
	@cd $(dotdir) && git submodule status
	@echo ""
	@echo "Checking symlinks..."
	@for f in gitconfig tigrc tmux.conf zpreztorc; do \
		if [ -L $(home)/.$$f ]; then \
			echo "  OK: ~/.$$f -> $$(readlink $(home)/.$$f)"; \
		else \
			echo "  MISSING: ~/.$$f"; \
		fi; \
	done
	@echo ""
	@echo "Checking git-crypt status..."
	@cd $(dotdir) && git-crypt status -e 2>/dev/null | head -5 || echo "  git-crypt not unlocked or not installed"
	@echo ""
	@echo "Done."

## Validate symlinks and configs
validate:
	@./scripts/validate.sh

# =============================================================================
# Symlink targets
# =============================================================================

$(xdg_apps): config_dir
	@if [ -d $(dotdir)/dotconfig/$@ ]; then \
		rm -rf $(home)/.config/$@ 2>/dev/null || true; \
		ln -sf $(dotdir)/dotconfig/$@ $(home)/.config/$@; \
		echo "Linked: ~/.config/$@"; \
	else \
		echo "Warning: dotconfig/$@ not found"; \
	fi

$(xdg_configs): config_dir
	@rm -rf $(home)/.config/$@ 2>/dev/null || true
	@ln -sf $(dotdir)/dot$@ $(home)/.config/$@
	@echo "Linked: ~/.config/$@"

$(prezto): dotfiles
	@ln -sf $(dotdir)/dotzprezto/runcoms/$@ $(home)/.$@
	@echo "Linked: ~/.$@"

$(privs): gpg
	@ln -sf $(dotdir)/dot$@ $(home)/.$@
	@echo "Linked: ~/.$@"

$(more):
	@if [ -e $(dotdir)/dot$@ ]; then \
		ln -sf $(dotdir)/dot$@ $(home)/.$@; \
		echo "Linked: ~/.$@"; \
	else \
		echo "Warning: dot$@ not found, skipping"; \
	fi

$(dev):
	@ln -sf $(dotdir)/$@ $(home)/.$@
	@echo "Linked: ~/.$@"

# =============================================================================
# Setup targets
# =============================================================================

config_dir:
	@mkdir -p $(home)/.config

dotfiles:
	@if [ ! -d $(dotdir) ]; then \
		git clone --recursive git@github.com:sysbot/dotfiles.git $(dotdir); \
	fi
	@cd $(dotdir) && git submodule update --init --recursive

$(GNUPGHOME):
	@echo "Error: GNUPGHOME needs to be mounted at $(GNUPGHOME)"
	@exit 1

## GPG/Yubikey setup
gpg:
	@echo "Checking GPG card status..."
	@gpg --card-status || echo "No smartcard detected"

# =============================================================================
# Homebrew targets
# =============================================================================

## Install base Homebrew packages
brewbase: brew
	@brew bundle check --file=$(dotdir)/Brewfile.base || brew bundle --file=$(dotdir)/Brewfile.base

## Install full Homebrew packages
brewfile: brew
	@brew bundle check --file=$(dotdir)/Brewfile || brew bundle --file=$(dotdir)/Brewfile

brew:
	@if ! command -v brew &>/dev/null; then \
		echo "Installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi

# =============================================================================
# Application-specific targets
# =============================================================================

## Install Doom Emacs
doom:
	@if [ ! -d $(home)/.emacs.d ]; then \
		git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d; \
		~/.emacs.d/bin/doom install; \
	else \
		echo "Doom already installed"; \
	fi

## Setup dnsmasq for local DNS
dnsmasq:
	@sudo mkdir -p /etc/resolver
	@echo "nameserver 127.0.0.1" | sudo tee /etc/resolver/dev > /dev/null
	@sudo brew services restart dnsmasq || echo "dnsmasq not installed"

## Setup Python virtualenv
virtualenv:
	@mkdir -p $(home)/Virtualenvs
	@if [ ! -d $(home)/Virtualenvs/default ]; then \
		python3 -m venv $(home)/Virtualenvs/default; \
	fi

# =============================================================================
# Cleanup
# =============================================================================

## Remove all symlinks (careful!)
clean:
	@echo "This will remove symlinks. Are you sure? [y/N]"
	@read ans && [ "$$ans" = "y" ]
	@for f in $(prezto) $(dev); do rm -f $(home)/.$$f; done
	@for f in $(xdg_configs) $(xdg_apps); do rm -rf $(home)/.config/$$f; done
	@echo "Cleaned up symlinks"

# =============================================================================
# Help
# =============================================================================

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

## Show this help
help:
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-20s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
