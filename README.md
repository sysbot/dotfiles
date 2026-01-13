# Dotfiles

Personal configuration files managed by **nix-darwin + Home Manager**.

## New Mac Setup (Complete Guide)

### Step 1: Install Xcode Command Line Tools
```bash
xcode-select --install
```

### Step 2: Clone Dotfiles
```bash
git clone https://github.com/sysbot/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### Step 3: Run Bootstrap
```bash
make bootstrap
```

This will:
1. Install **Nix** (Determinate Systems installer)
2. Install **Homebrew** (for GUI apps/casks)
3. Run **darwin-rebuild** (nix-darwin + home-manager)
4. Install **Doom Emacs**

If Nix wasn't installed, restart your terminal and run `make bootstrap` again.

### Step 4: Unlock Secrets (if you have GPG key)
```bash
make unlock
```

### Step 5: Setup Claude Code Config Symlink
```bash
# Backup existing config if any
mv ~/.claude ~/.claude.bak 2>/dev/null || true

# Create symlink
ln -s ~/dotfiles/dotclaude ~/.claude

# Restore ephemeral data from backup
cp -r ~/.claude.bak/{history.jsonl,settings.local.json,agent-state,session-env,todos,telemetry,statsig,plugins,downloads} ~/.claude/ 2>/dev/null || true

# Cleanup backup
rm -rf ~/.claude.bak
```

### Step 6: Verify Installation
```bash
make doctor
```

### Step 7: Sync Homebrew Casks
```bash
brewsync   # or: brew bundle --file=~/dotfiles/Brewfile
```

---

## Quick Reference

| Command | Description |
|---------|-------------|
| `make switch` | Apply nix config (daily use) |
| `make update` | Update all flake inputs |
| `make rollback` | Undo last switch |
| `make doctor` | Health check |
| `make doom-sync` | Sync Doom packages |
| `make gc` | Garbage collect old generations |
| `make help` | Show all targets |

---

## Manual Installation (Alternative)

### Prerequisites

1. Install Nix (Determinate Systems - recommended):
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

2. Install Homebrew:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Installation

**Option 1: Home Manager standalone** (simpler)
```bash
cd ~/dotfiles
nix run home-manager -- switch --flake .#bao
```

**Option 2: nix-darwin + Home Manager** (full macOS integration, recommended)
```bash
cd ~/dotfiles
nix run nix-darwin -- switch --flake .#macbook
```

### Daily Usage

```bash
# Apply configuration changes
home-manager switch --flake ~/dotfiles

# Or with nix-darwin (recommended for macOS)
darwin-rebuild switch --flake ~/dotfiles

# Sync Homebrew casks (run manually when Brewfile changes)
brewsync

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
├── Brewfile            # Homebrew casks (run `brewsync` manually)
├── modules/
│   ├── packages.nix    # CLI packages (managed by Nix)
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
⏺ Done. Key commands:

  | Command        | Description                     |
  |----------------|---------------------------------|
  | make switch    | Apply nix config (daily use)    |
  | make bootstrap | First-time setup on new Mac     |
  | make update    | Update all flake inputs         |
  | make rollback  | Undo last switch                |
  | make doctor    | Health check                    |
  | make doom      | Install Doom Emacs              |
  | make doom-sync | Sync Doom packages              |
  | make gc        | Garbage collect old generations |
  | make help      | Show all targets                |

⏺ ┌─────────────────────────────────────────────────────────────────────────────┐
  │                              ~/dotfiles/flake.nix                            │
  │                                                                              │
  │  inputs: nixpkgs, home-manager, darwin, emacs-overlay                       │
  └─────────────────────────────────┬────────────────────────────────────────────┘
                                    │
                                    ▼
          ┌─────────────────────────┴─────────────────────────┐
          │                                                   │
          ▼                                                   ▼
  ┌───────────────────┐                             ┌───────────────────┐
  │   darwin.nix      │                             │    home.nix       │
  │   (system-level)  │                             │   (user-level)    │
  ├───────────────────┤                             ├───────────────────┤
  │ • macOS defaults  │                             │ imports:          │
  │ • Dock/Finder     │                             │ ├─ packages.nix   │
  │ • Keyboard        │                             │ ├─ git.nix        │
  │ • Touch ID sudo   │                             │ ├─ shell.nix      │
  │ • Nix settings    │                             │ ├─ tmux.nix       │
  │ • Launchd agents  │                             │ ├─ terminals.nix  │
  │                   │                             │ └─ emacs.nix      │
  │                   │                             └─────────┬─────────┘
  └───────────────────┘                                       │
                                                              │
          ┌───────────────────────────────────────────────────┼───────────┐
          │                                                   │           │
          ▼                                                   ▼           ▼
  ┌─────────────────────────┐                    ┌────────────────────────────┐
  │  MANAGED BY HOME-MANAGER │                    │  EMACS (special case)      │
  │  (programs.* modules)    │                    │                            │
  ├─────────────────────────┤                    ├────────────────────────────┤
  │                         │                    │  modules/emacs.nix         │
  │  programs.tmux          │                    │  ┌────────────────────────┐│
  │  ├─ enable = true       │                    │  │ emacs-overlay          ││
  │  ├─ prefix = "C-o"      │                    │  │ (custom input)         ││
  │  ├─ plugins = [...]     │                    │  └──────────┬─────────────┘│
  │  └─ extraConfig = ''    │                    │             │              │
  │       ...               │                    │             ▼              │
  │     ''                  │                    │  ┌────────────────────────┐│
  │                         │                    │  │ pkgs.emacs-macport     ││
  │  programs.zsh           │                    │  │   .override {          ││
  │  ├─ shellAliases        │                    │  │     withNativeComp     ││
  │  ├─ sessionVariables    │                    │  │     withTreeSitter     ││
  │  ├─ initExtra           │                    │  │   }                    ││
  │  └─ prezto.enable       │                    │  │   .overrideAttrs {     ││
  │                         │                    │  │     version = "29.4"   ││
  │  programs.starship      │                    │  │   }                    ││
  │  programs.fzf           │                    │  └──────────┬─────────────┘│
  │  programs.zoxide        │                    │             │              │
  │  programs.bat           │                    │             ▼              │
  │  programs.eza           │                    │  Binary: emacs, emacsclient│
  │  programs.direnv        │                    │                            │
  │                         │                    │  Config: EXTERNAL          │
  └────────────┬────────────┘                    │  └─ ~/.config/emacs/       │
               │                                 │     (Doom Emacs)           │
               ▼                                 │     - init.el              │
  ┌─────────────────────────┐                    │     - config.el            │
  │  GENERATES DOTFILES     │                    │     - packages.el          │
  ├─────────────────────────┤                    │                            │
  │ ~/.tmux.conf            │                    │  NOT managed by Nix!       │
  │ ~/.zshrc                │                    │  Doom manages its own      │
  │ ~/.config/starship.toml │                    │  packages via straight.el  │
  │ ~/.config/bat/          │                    └────────────────────────────┘
  │ etc...                  │
  └─────────────────────────┘


  ═══════════════════════════════════════════════════════════════════════════════
                                     SUMMARY
  ═══════════════════════════════════════════════════════════════════════════════

  ┌─────────────────┬──────────────────────────┬─────────────────────────────────┐
  │ Tool            │ Binary from              │ Config from                     │
  ├─────────────────┼──────────────────────────┼─────────────────────────────────┤
  │ tmux            │ Nix (programs.tmux)      │ Nix → ~/.tmux.conf              │
  │ zsh             │ Nix (programs.zsh)       │ Nix → ~/.zshrc                  │
  │ starship        │ Nix (programs.starship)  │ Nix → ~/.config/starship.toml   │
  │ git             │ Nix (programs.git)       │ Nix → ~/.gitconfig              │
  │ ssh             │ Nix (programs.ssh)       │ Nix → ~/.ssh/config             │
  ├─────────────────┼──────────────────────────┼─────────────────────────────────┤
  │ Emacs           │ Nix (emacs-overlay)      │ Doom Emacs (~/.config/emacs)    │
  │                 │ └─ 29.4 + native-comp    │ └─ NOT managed by Nix           │
  ├─────────────────┼──────────────────────────┼─────────────────────────────────┤
  │ Ghostty, etc.   │ Homebrew (Brewfile)      │ App manages own config          │
  │                 │ └─ run `brewsync`        │                                 │
  └─────────────────┴──────────────────────────┴─────────────────────────────────┘

  Key difference:
  - tmux/zsh/starship: Nix manages both binary AND config
  - Emacs: Nix manages binary (with custom overlay), but Doom manages packages/config externally


### macOS Settings (via nix-darwin)
- Dock: autohide, no recents
- Finder: show all files, list view
- Keyboard: caps lock → escape, fast repeat
- Touch ID for sudo

### SSH Agent
Configured via `programs.ssh` in home.nix:
- Keys auto-added to agent on first use
- Passphrases stored in macOS Keychain
- `~/.ssh/key_personal` loaded automatically on shell start

### GUI Apps (via Homebrew casks)
Managed separately from nix-darwin for faster rebuilds:
- Ghostty, Chrome, Spotify, VLC, Slack, Discord, OrbStack, etc.

```bash
# Sync casks manually when Brewfile changes
brewsync

# Or directly
brew bundle --file=~/dotfiles/Brewfile --cleanup
```

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
