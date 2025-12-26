# Dotfiles Makefile
# Updated: December 2025
#
# Nix-Darwin + Home Manager workflow
#
# Usage:
#   make switch    - Apply nix configuration (primary command)
#   make bootstrap - First-time setup on a new Mac
#   make update    - Update flake inputs
#   make doctor    - Health check

home = $(HOME)
dotdir = $(home)/dotfiles

# =============================================================================
# Primary targets
# =============================================================================

.PHONY: switch bootstrap update doctor clean help

## Apply nix-darwin configuration
switch:
	@cd $(dotdir) && sudo darwin-rebuild switch --flake '.#macbook' --impure

## Update flake inputs
update:
	@cd $(dotdir) && nix flake update

## Update specific input (usage: make update-input INPUT=emacs-overlay)
update-input:
	@cd $(dotdir) && nix flake update $(INPUT)

## Rollback to previous generation
rollback:
	@sudo darwin-rebuild --rollback

## Show available generations
generations:
	@darwin-rebuild --list-generations | tail -20

# =============================================================================
# Bootstrap (new machine setup)
# =============================================================================

## Full bootstrap on a new Mac
bootstrap: nix brew switch doom
	@echo "Bootstrap complete!"
	@echo "Open a new terminal to use the new shell."

## Install Nix
nix:
	@if ! command -v nix &>/dev/null; then \
		echo "Installing Nix..."; \
		curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install; \
		echo "Please restart your shell and run 'make bootstrap' again"; \
		exit 1; \
	else \
		echo "Nix already installed"; \
	fi

## Install Homebrew (needed for casks)
brew:
	@if ! command -v brew &>/dev/null; then \
		echo "Installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	else \
		echo "Homebrew already installed"; \
	fi

## Install Doom Emacs
doom:
	@if [ ! -d $(home)/.config/emacs ]; then \
		git clone --depth 1 https://github.com/doomemacs/doomemacs $(home)/.config/emacs; \
		$(home)/.config/emacs/bin/doom install; \
	else \
		echo "Doom already installed at ~/.config/emacs"; \
	fi

## Sync Doom packages
doom-sync:
	@$(home)/.config/emacs/bin/doom sync

## Upgrade Doom
doom-upgrade:
	@$(home)/.config/emacs/bin/doom upgrade

# =============================================================================
# Health check
# =============================================================================

## Health check for dotfiles
doctor:
	@echo "=== Dotfiles Health Check ==="
	@echo ""
	@echo "Nix version:"
	@nix --version 2>/dev/null || echo "  NOT INSTALLED"
	@echo ""
	@echo "Darwin generation:"
	@darwin-rebuild --list-generations 2>/dev/null | tail -1 || echo "  nix-darwin not installed"
	@echo ""
	@echo "Home Manager:"
	@home-manager --version 2>/dev/null || echo "  (managed by nix-darwin)"
	@echo ""
	@echo "Flake inputs:"
	@cd $(dotdir) && nix flake metadata --json 2>/dev/null | jq -r '.locks.nodes | keys[]' | grep -v root | while read input; do \
		echo "  $$input"; \
	done
	@echo ""
	@echo "Git-crypt status:"
	@cd $(dotdir) && git-crypt status -e 2>/dev/null | head -3 || echo "  Not unlocked"
	@echo ""
	@echo "Emacs:"
	@emacs --version 2>/dev/null | head -1 || echo "  NOT INSTALLED"
	@echo ""
	@echo "Done."

# =============================================================================
# Git-crypt / secrets
# =============================================================================

## Unlock encrypted files (requires GPG key)
unlock:
	@cd $(dotdir) && git-crypt unlock

## Check encryption status
secrets:
	@cd $(dotdir) && git-crypt status

# =============================================================================
# Development
# =============================================================================

## Open nix dev shell
dev:
	@cd $(dotdir) && nix develop

## Format nix files
fmt:
	@cd $(dotdir) && nixpkgs-fmt *.nix modules/*.nix

## Check flake
check:
	@cd $(dotdir) && nix flake check

# =============================================================================
# Cleanup
# =============================================================================

## Garbage collect old generations
gc:
	@sudo nix-collect-garbage -d
	@nix-collect-garbage -d

## Remove old generations (keep last 5)
gc-old:
	@sudo nix-env --delete-generations +5
	@nix-collect-garbage

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
