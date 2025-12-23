#!/bin/bash
# Dotfiles validation script
# Checks symlinks, submodules, and git-crypt status

set -e

DOTDIR="${HOME}/dotfiles"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo "=== Dotfiles Validation ==="
echo ""

errors=0
warnings=0

# Check if dotfiles directory exists
if [ ! -d "$DOTDIR" ]; then
    echo -e "${RED}ERROR: Dotfiles directory not found at $DOTDIR${NC}"
    exit 1
fi

# =============================================================================
# Check symlinks
# =============================================================================
echo "Checking symlinks..."

check_symlink() {
    local name=$1
    local target=$2
    local path="${HOME}/.${name}"

    if [ -L "$path" ]; then
        local actual=$(readlink "$path")
        echo -e "  ${GREEN}OK${NC}: ~/.$name -> $actual"
    elif [ -e "$path" ]; then
        echo -e "  ${YELLOW}WARN${NC}: ~/.$name exists but is not a symlink"
        ((warnings++))
    else
        echo -e "  ${RED}MISSING${NC}: ~/.$name"
        ((errors++))
    fi
}

# Shell configs
check_symlink "zpreztorc"
check_symlink "zshrc"
check_symlink "zshenv"
check_symlink "zprofile"
check_symlink "zlogin"
check_symlink "zlogout"

# Dev configs
check_symlink "gitconfig"
check_symlink "tigrc"
check_symlink "tmux.conf"

echo ""

# =============================================================================
# Check XDG config symlinks
# =============================================================================
echo "Checking XDG config symlinks..."

check_xdg_symlink() {
    local name=$1
    local path="${HOME}/.config/${name}"

    if [ -L "$path" ]; then
        local actual=$(readlink "$path")
        echo -e "  ${GREEN}OK${NC}: ~/.config/$name -> $actual"
    elif [ -d "$path" ]; then
        echo -e "  ${YELLOW}INFO${NC}: ~/.config/$name exists (not symlinked)"
    else
        echo -e "  ${YELLOW}MISSING${NC}: ~/.config/$name (optional)"
    fi
}

check_xdg_symlink "ghostty"
check_xdg_symlink "kitty"
check_xdg_symlink "zed"

echo ""

# =============================================================================
# Check submodules
# =============================================================================
echo "Checking submodules..."

cd "$DOTDIR"
while IFS= read -r line; do
    status="${line:0:1}"
    path=$(echo "$line" | awk '{print $2}')

    case "$status" in
        " ")
            echo -e "  ${GREEN}OK${NC}: $path"
            ;;
        "+")
            echo -e "  ${YELLOW}MODIFIED${NC}: $path (local changes)"
            ((warnings++))
            ;;
        "-")
            echo -e "  ${RED}MISSING${NC}: $path (not initialized)"
            ((errors++))
            ;;
        "U")
            echo -e "  ${RED}CONFLICT${NC}: $path (merge conflict)"
            ((errors++))
            ;;
    esac
done < <(git submodule status 2>/dev/null)

echo ""

# =============================================================================
# Check git-crypt status
# =============================================================================
echo "Checking git-crypt..."

if command -v git-crypt &>/dev/null; then
    cd "$DOTDIR"
    if git-crypt status -e &>/dev/null; then
        encrypted_count=$(git-crypt status -e 2>/dev/null | wc -l | tr -d ' ')
        echo -e "  ${GREEN}OK${NC}: git-crypt unlocked ($encrypted_count encrypted files)"
    else
        echo -e "  ${YELLOW}LOCKED${NC}: git-crypt is locked (run 'git-crypt unlock')"
        ((warnings++))
    fi
else
    echo -e "  ${YELLOW}WARN${NC}: git-crypt not installed"
    ((warnings++))
fi

echo ""

# =============================================================================
# Check for orphaned dotfiles
# =============================================================================
echo "Checking for potential orphans in dotfiles..."

orphans=()
for f in "$DOTDIR"/dot*; do
    if [ -f "$f" ] || [ -d "$f" ]; then
        name=$(basename "$f" | sed 's/^dot//')
        if [ ! -e "${HOME}/.${name}" ] && [ ! -e "${HOME}/.config/${name}" ]; then
            orphans+=("$name")
        fi
    fi
done

if [ ${#orphans[@]} -gt 0 ]; then
    echo -e "  ${YELLOW}ORPHANS${NC}: The following configs are not linked:"
    for o in "${orphans[@]}"; do
        echo "    - $o"
    done
    ((warnings++))
else
    echo -e "  ${GREEN}OK${NC}: No orphaned configs found"
fi

echo ""

# =============================================================================
# Summary
# =============================================================================
echo "=== Summary ==="
if [ $errors -eq 0 ] && [ $warnings -eq 0 ]; then
    echo -e "${GREEN}All checks passed!${NC}"
    exit 0
elif [ $errors -eq 0 ]; then
    echo -e "${YELLOW}$warnings warning(s), 0 errors${NC}"
    exit 0
else
    echo -e "${RED}$errors error(s), $warnings warning(s)${NC}"
    exit 1
fi
