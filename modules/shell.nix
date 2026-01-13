{ pkgs, config, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = false;  # Using prezto's autosuggestions instead
    enableCompletion = false;  # Using prezto's completion instead
    syntaxHighlighting.enable = false;  # Using prezto's syntax-highlighting instead

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
      # Emacs
      em = "emacsclient -t";                        # terminal mode
      vi = "emacsclient -t";                        # terminal mode
      e = "emacsclient -n";                         # open in existing frame (no wait)
      emacs = "emacsclient -n -a emacs";            # open in existing frame, fallback to new

      # Modern replacements
      ls = "eza";
      ll = "eza -la";
      la = "eza -a";
      lt = "eza --tree";
      cat = "bat";
      grep = "rg";
      find = "fd";
      cd = "z";

      # Git shortcuts
      g = "git status";
      d = "git diff";
      gs = "git status";
      gd = "git diff";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";

      # Safety
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";

      # Misc
      reload = "source ~/.zshrc";
      path = "echo $PATH | tr ':' '\\n'";
      week = "date +%V";
      p = "~/bin/passage";

      # Homebrew sync (run manually when Brewfile changes)
      brewsync = "brew bundle --file=~/dotfiles/Brewfile --cleanup";
    };

    sessionVariables = {
      EDITOR = "emacsclient -t";
      VISUAL = "emacsclient -c";
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      # Enable Claude Code LSP integration
      ENABLE_LSP_TOOL = "1";
    };

    initContent = ''
      # Start in home directory if at root
      [[ "$PWD" == "/" ]] && cd ~

      # =========================================================================
      # Custom Functions (from dotzshrc)
      # =========================================================================

      # Extract archives
      extract() {
        if [ -f $1 ]; then
          case $1 in
            *.tar.bz2) tar xjf $1 ;;
            *.tar.xz)  tar xJf $1 ;;
            *.tar.gz)  tar xzf $1 ;;
            *.bz2)     bunzip2 $1 ;;
            *.rar)     unrar x $1 ;;
            *.gz)      gunzip $1 ;;
            *.tar)     tar xf $1 ;;
            *.tbz2)    tar xjf $1 ;;
            *.tgz)     tar xzf $1 ;;
            *.zip)     unzip $1 ;;
            *.Z)       uncompress $1 ;;
            *.7z)      7zr e $1 ;;
            *)         echo "'$1' cannot be extracted via extract()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }

      # Tmux session helpers
      remote() {
        if [[ "$TMUX" == "" ]]; then
          tmux attach -t remote || tmux new -s remote
          exit 0
        fi
      }

      work() {
        if [[ "$TMUX" == "" ]]; then
          tmux attach -t work || tmux new -s work
          exit 0
        fi
      }

      # HEIC to JPEG conversion
      heic2jpeg() {
        mogrify -format jpg *.heic
      }

      # =========================================================================
      # Tool Integrations
      # =========================================================================

      # Direnv
      eval "$(direnv hook zsh)"

      # Zoxide (smart cd)
      eval "$(zoxide init zsh)"

      # FZF
      eval "$(fzf --zsh)"

      # =========================================================================
      # Path additions
      # =========================================================================
      export PATH="/opt/homebrew/bin:$PATH"
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$HOME/go/bin:$PATH"
      export PATH="$HOME/.cargo/bin:$PATH"
      export PATH="$HOME/bin:$PATH"
      export PATH="$HOME/.config/emacs/bin:$PATH"

      # =========================================================================
      # SSH Agent (macOS) - Use launchd-managed agent with Keychain
      # =========================================================================
      if [[ "$(uname)" == "Darwin" ]]; then
        # Use macOS launchd-managed ssh-agent socket (persists across all sessions)
        if [[ -z "$SSH_AUTH_SOCK" ]]; then
          export SSH_AUTH_SOCK=$(ls /private/tmp/com.apple.launchd.*/Listeners 2>/dev/null | head -1)
        fi

        # Load keys from Keychain (passphrase stored with --apple-use-keychain)
        ssh-add --apple-load-keychain 2>/dev/null

        # Add key_personal if not in agent
        if [[ -f ~/.ssh/key_personal ]]; then
          ssh-add -l 2>/dev/null | grep -q "key_personal" || \
            ssh-add --apple-use-keychain ~/.ssh/key_personal 2>/dev/null
        fi
      fi

      # =========================================================================
      # Nix
      # =========================================================================
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi

      # =========================================================================
      # Local overrides (machine-specific config)
      # =========================================================================
      if [ -f ~/.zshrc.local ]; then
        source ~/.zshrc.local
      fi
    '';

    # Prezto (alternative to oh-my-zsh)
    prezto = {
      enable = true;
      pmodules = [
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "spectrum"
        "utility"
        "completion"
        "syntax-highlighting"
        "history-substring-search"
        "autosuggestions"
      ];
      editor = {
        keymap = "vi";
        dotExpansion = true;
      };
      prompt.theme = "off";  # Using starship instead
      terminal.autoTitle = true;
      utility.safeOps = true;
    };
  };

  # Additional shell tools
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
    ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
      pager = "less -FR";
    };
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$directory$character";
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = false;
      };
      # Disable everything else
      git_branch.disabled = true;
      git_status.disabled = true;
      git_commit.disabled = true;
      git_state.disabled = true;
      nix_shell.disabled = true;
      nodejs.disabled = true;
      python.disabled = true;
      rust.disabled = true;
      golang.disabled = true;
      package.disabled = true;
      cmd_duration.disabled = true;
    };
  };

  # Atuin - better shell history with sync
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];  # Don't override up arrow, use ctrl-r
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      search_mode = "fuzzy";
      filter_mode = "global";
      style = "compact";
      inline_height = 20;
      show_preview = true;
      # Privacy
      update_check = false;
      # Performance
      search_mode_shell_up_key_binding = "prefix";
    };
  };
}
