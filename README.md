# Dotfiles

Personal configuration files managed by **Nix Home Manager**.

## Quick Start

### Prerequisites

1. Install Nix:
```bash
curl -L https://nixos.org/nix/install | sh
```

2. Enable flakes (add to `~/.config/nix/nix.conf`):
```
experimental-features = nix-command flakes
```

### Installation

**Option 1: Home Manager standalone** (simpler)
```bash
cd ~/dotfiles
nix run home-manager -- switch --flake .#bao
```

**Option 2: nix-darwin + Home Manager** (full macOS integration)
```bash
cd ~/dotfiles
nix run nix-darwin -- switch --flake .#macbook
```

### Daily Usage

```bash
# Apply configuration changes
home-manager switch --flake ~/dotfiles

# Or with nix-darwin
darwin-rebuild switch --flake ~/dotfiles

# Update flake inputs
nix flake update

# Check what would change
home-manager build --flake ~/dotfiles
```

## Structure

```
~/dotfiles/
├── flake.nix           # Flake entry point with inputs
├── flake.lock          # Pinned dependencies
├── home.nix            # Main Home Manager configuration
├── darwin.nix          # macOS system configuration (nix-darwin)
├── modules/
│   ├── packages.nix    # All packages (replaces Brewfile)
│   ├── shell.nix       # Zsh + Prezto + tools
│   ├── git.nix         # Git configuration
│   ├── tmux.nix        # Tmux configuration
│   └── terminals.nix   # Kitty, Alacritty
├── dotconfig/          # Raw config files
│   ├── ghostty/
│   └── zed/
└── secrets/            # Encrypted (git-crypt)
    ├── dotssh/
    └── dotpassword-store/
```

## What's Managed

### Packages (via Nix)
- Core: coreutils, findutils, gnused, gnumake
- Shell: zsh, bash, starship, fzf, zoxide
- Dev: git, gh, delta, ripgrep, fd, jq
- Languages: python, go, rust, node, ruby
- Cloud: awscli, terraform, kubectl
- Media: ffmpeg, imagemagick

### Programs (via Home Manager)
- **Git**: Full config with 50+ aliases, delta integration
- **Zsh**: Prezto, autosuggestions, syntax highlighting
- **Tmux**: Vi mode, plugins (resurrect, continuum)
- **Kitty**: Dracula theme, Nerd Fonts
- **Alacritty**: Minimal config

### macOS Settings (via nix-darwin)
- Dock: autohide, no recents
- Finder: show all files, list view
- Keyboard: caps lock → escape, fast repeat
- Touch ID for sudo

### GUI Apps (via Homebrew casks)
- Docker, Chrome, Spotify, VLC, Slack, 1Password

## Customization

### Add a package
Edit `modules/packages.nix`:
```nix
home.packages = with pkgs; [
  # Add your package here
  neovim
];
```

### Add a shell alias
Edit `modules/shell.nix`:
```nix
shellAliases = {
  myalias = "my command";
};
```

### Machine-specific config
Create `~/.zshrc.local` for machine-specific settings (sourced automatically).

## Migration from Makefile

The old Makefile-based approach is archived. Key differences:

| Old (Makefile) | New (Nix) |
|----------------|-----------|
| `make base` | `home-manager switch --flake .` |
| `make full` | `darwin-rebuild switch --flake .` |
| Brewfile | `modules/packages.nix` |
| gitconfig | `modules/git.nix` |
| tmux.conf | `modules/tmux.nix` |
| zshrc | `modules/shell.nix` |

## Troubleshooting

### Rebuild after changes
```bash
home-manager switch --flake ~/dotfiles
```

### Check for errors
```bash
nix flake check
home-manager build --flake ~/dotfiles
```

### Update all packages
```bash
nix flake update
home-manager switch --flake ~/dotfiles
```

### Rollback
```bash
home-manager generations  # List generations
home-manager switch --flake ~/dotfiles --rollback
```

### Clean old generations
```bash
nix-collect-garbage -d
```

## Encrypted Secrets

Some directories are encrypted with git-crypt:
- `dotssh/` - SSH keys and config
- `dotpassword-store/` - Password store

To unlock:
```bash
git-crypt unlock
```

## License

MIT
