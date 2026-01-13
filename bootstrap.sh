#!/bin/bash
# Bootstrap script for new Mac
# Run with: curl -fsSL https://raw.githubusercontent.com/sysbot/dotfiles/master/bootstrap.sh | bash
# Or locally: ./bootstrap.sh

set -e

echo "=== Dotfiles Bootstrap ==="
echo ""

# Step 1: Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
    echo "[1/5] Installing Xcode Command Line Tools..."
    xcode-select --install
    echo ""
    echo "Please wait for Xcode CLT to finish installing, then run this script again."
    exit 0
else
    echo "[1/5] Xcode Command Line Tools: already installed"
fi

# Step 2: Clone dotfiles if not present
if [ ! -d "$HOME/dotfiles" ]; then
    echo "[2/5] Cloning dotfiles..."
    git clone https://github.com/sysbot/dotfiles.git "$HOME/dotfiles"
else
    echo "[2/5] Dotfiles: already cloned"
fi

cd "$HOME/dotfiles"

# Step 3: Install Nix
if ! command -v nix &>/dev/null; then
    echo "[3/5] Installing Nix..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    echo ""
    echo "Nix installed. Please restart your terminal and run this script again."
    exit 0
else
    echo "[3/5] Nix: already installed"
fi

# Step 4: Install Homebrew
if ! command -v brew &>/dev/null; then
    echo "[4/5] Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add brew to path for this session
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "[4/5] Homebrew: already installed"
fi

# Step 5: Run nix-darwin
echo "[5/5] Running darwin-rebuild..."
if command -v darwin-rebuild &>/dev/null; then
    darwin-rebuild switch --flake "$HOME/dotfiles#macbook" --impure
else
    echo "First-time nix-darwin install..."
    nix run nix-darwin -- switch --flake "$HOME/dotfiles#macbook" --impure
fi

echo ""
echo "=== Bootstrap Complete ==="
echo ""
echo "Next steps:"
echo "  1. Open a new terminal"
echo "  2. Run: make unlock     (if you have GPG key for secrets)"
echo "  3. Run: make doom       (to install Doom Emacs)"
echo "  4. Run: brewsync        (to install GUI apps)"
echo "  5. Setup Claude: ln -s ~/dotfiles/dotclaude ~/.claude"
echo ""
