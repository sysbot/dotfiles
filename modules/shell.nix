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
      em = "emacsclient -t";
      vi = "emacsclient -t";
      emacs = "emacsclient --no-wait -c -a emacs";

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
      g = "git";
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
    };

    sessionVariables = {
      EDITOR = "emacsclient -t";
      VISUAL = "emacsclient -c";
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };

    initExtra = ''
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
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$HOME/go/bin:$PATH"
      export PATH="$HOME/.cargo/bin:$PATH"

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
        "prompt"
        "git"
        "syntax-highlighting"
        "history-substring-search"
        "autosuggestions"
      ];
      editor = {
        keymap = "vi";
        dotExpansion = true;
      };
      prompt.theme = "sorin";
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
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      git_branch.symbol = " ";
      git_status = {
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
      };
      nix_shell = {
        symbol = " ";
        format = "via [$symbol$state]($style) ";
      };
    };
  };
}
