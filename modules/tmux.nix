{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-o";
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    mouse = false;
    sensibleOnTop = false;  # Disable sensible plugin (uses outdated reattach-to-user-namespace)

    plugins = with pkgs.tmuxPlugins; [
      yank
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10'
        '';
      }
    ];

    extraConfig = ''
      # Override default-command (disable reattach-to-user-namespace, not needed on modern macOS)
      set -g default-command "${pkgs.zsh}/bin/zsh"

      # Size windows based on largest client (smaller clients see viewport)
      set -g window-size largest

      # Repeat time
      set -g repeat-time 35

      # Kill bindings
      unbind &
      bind-key & kill-window
      unbind x
      bind-key x kill-pane

      # Swap panes
      bind-key -n C-S-Left swap-window -t -1
      bind-key -n C-S-Right swap-window -t +1

      # Reload config
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      # Split bindings
      unbind %
      bind | split-window -h
      bind - split-window -v
      bind-key _ split-window -v

      # Vim-like pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind-key -r C-h select-window -t :-
      bind-key -r C-l select-window -t :+

      # Pane resizing
      bind-key J resize-pane -D
      bind-key K resize-pane -U
      bind-key H resize-pane -L
      bind-key L resize-pane -R

      # Smart pane switching with vim awareness
      bind -n C-h run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-h) || tmux select-pane -L"
      bind -n C-j run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-j) || tmux select-pane -D"
      bind -n C-k run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-k) || tmux select-pane -U"
      bind -n C-l run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-l) || tmux select-pane -R"

      # Terminal settings
      set -g terminal-overrides 'xterm*:smcup@:rmcup@'
      set -g xterm-keys on
      setw -g pane-base-index 1

      # Status bar position
      set -g status-position top
      set -g status on
      set -g status-interval 4
      set -g status-left-length 90
      set -g status-right-length 90
      set -g status-justify left

      # Colors
      set -g status-bg black
      set -g status-fg white
      set -g pane-border-style fg=colour235
      set -g pane-active-border-style fg=colour235

      # Status bar content
      set -g status-left "#[fg=Green]#(whoami)#[fg=white]::#[fg=gray]#(hostname -s)#[fg=white]::"
      set -g status-right "#(~/dotfiles/scripts/claude-status --tmux-status) #[fg=Cyan]#S"

      # Claude agent status popup (prefix + a)
      bind-key a display-popup -E -w 50 -h 20 "~/dotfiles/scripts/claude-status"

      # Auto rename windows based on current command
      set -g automatic-rename on
      set -g automatic-rename-format '#{b:pane_current_path}'

      # Rename session to current dir
      bind-key S run-shell "tmux rename-session $(basename $(pwd))"

      # Window navigation
      bind-key n next-window
      bind-key p previous-window

      # Copy mode (vi style)
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
      unbind-key -T copy-mode-vi Enter
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy"
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle

      # Paste time (for iTerm2)
      set -g assume-paste-time 0
    '';
  };
}
