# Dotfiles

Personal configuration files for macOS.

## Quick Start

```bash
# Clone the repository
git clone --recursive git@github.com:sysbot/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Minimal installation (shell, git, basic tools)
make base

# Full installation (everything)
make full

# Just XDG config apps (ghostty, kitty, zed)
make config

# Health check
make doctor
```

## What's Included

### Shell
- **Prezto** - Zsh configuration framework
- Custom `.zshrc` with functions and aliases

### Development
- Git configuration with extensive aliases
- Tig (git TUI)
- Tmux configuration

### XDG Config Apps
- **Ghostty** - Terminal emulator
- **Kitty** - Terminal emulator
- **Zed** - Editor

### Communication
- Mutt/mu4e (email)
- Weechat (IRC)

### Security
- GPG/Yubikey integration
- git-crypt for encrypted directories

## Directory Structure

```
dotfiles/
├── Brewfile          # Full Homebrew packages
├── Brewfile.base     # Essential packages only
├── Makefile          # Installation orchestration
├── dotconfig/        # XDG config apps
│   ├── ghostty/
│   ├── kitty/
│   └── zed/
├── dotzprezto/       # Zsh framework (submodule)
├── dotssh/           # SSH config (encrypted)
├── dotsec/           # Secrets (encrypted)
├── dotmutt/          # Email config (submodule)
├── dotweechat/       # IRC config (submodule)
└── gitconfig         # Git configuration
```

## Make Targets

| Target | Description |
|--------|-------------|
| `make base` | Minimal: Homebrew base + shell + git |
| `make full` | Everything including encrypted dirs |
| `make config` | XDG apps (ghostty, kitty, zed) |
| `make doctor` | Health check for symlinks/submodules |
| `make brewbase` | Install base Homebrew packages |
| `make brewfile` | Install full Homebrew packages |
| `make doom` | Install Doom Emacs |
| `make clean` | Remove symlinks |
| `make help` | Show all targets |

## Encrypted Directories

Some directories are encrypted with git-crypt:
- `dotssh/` - SSH configuration
- `dotsec/` - Secrets
- `dotgcloud/` - Google Cloud config

To unlock:
```bash
# Requires GPG key setup
git-crypt unlock
```

## Submodules

Update all submodules:
```bash
git submodule update --init --recursive
git submodule foreach git pull origin master
```

## Troubleshooting

### Symlinks broken
```bash
make doctor   # Check status
make clean    # Remove all
make base     # Reinstall
```

### Submodules missing
```bash
git submodule update --init --recursive
```

### Homebrew issues
```bash
brew bundle check --file=Brewfile.base
brew bundle --file=Brewfile.base
```

## License

MIT
