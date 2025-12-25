{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 14;
    };

    settings = {
      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;

      # Scrollback
      scrollback_lines = 10000;

      # Bell
      enable_audio_bell = false;
      visual_bell_duration = "0.0";

      # Window
      window_padding_width = 4;
      hide_window_decorations = "titlebar-only";
      confirm_os_window_close = 0;

      # Tab bar
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";

      # Colors (Dracula-inspired)
      foreground = "#f8f8f2";
      background = "#282a36";
      selection_foreground = "#ffffff";
      selection_background = "#44475a";

      # Cursor
      cursor = "#f8f8f2";
      cursor_shape = "beam";
      cursor_blink_interval = "0.5";

      # URLs
      url_color = "#8be9fd";
      url_style = "single";

      # macOS specific
      macos_titlebar_color = "background";
      macos_option_as_alt = "both";
      macos_quit_when_last_window_closed = true;

      # Shell
      shell = "zsh";
    };

    keybindings = {
      # Window management
      "cmd+n" = "new_os_window";
      "cmd+w" = "close_window";
      "cmd+t" = "new_tab";
      "cmd+shift+]" = "next_tab";
      "cmd+shift+[" = "previous_tab";

      # Font size
      "cmd+plus" = "change_font_size all +1.0";
      "cmd+minus" = "change_font_size all -1.0";
      "cmd+0" = "change_font_size all 0";

      # Scrolling
      "cmd+up" = "scroll_line_up";
      "cmd+down" = "scroll_line_down";
      "cmd+page_up" = "scroll_page_up";
      "cmd+page_down" = "scroll_page_down";
      "cmd+home" = "scroll_home";
      "cmd+end" = "scroll_end";

      # Copy/paste
      "cmd+c" = "copy_to_clipboard";
      "cmd+v" = "paste_from_clipboard";
    };

    extraConfig = ''
      # Color scheme - Dracula
      color0  #21222c
      color1  #ff5555
      color2  #50fa7b
      color3  #f1fa8c
      color4  #bd93f9
      color5  #ff79c6
      color6  #8be9fd
      color7  #f8f8f2
      color8  #6272a4
      color9  #ff6e6e
      color10 #69ff94
      color11 #ffffa5
      color12 #d6acff
      color13 #ff92df
      color14 #a4ffff
      color15 #ffffff
    '';
  };

  # Alacritty as alternative terminal
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 4;
          y = 4;
        };
        decorations = "buttonless";
        opacity = 1.0;
      };

      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        size = 14.0;
      };

      colors = {
        primary = {
          background = "#282a36";
          foreground = "#f8f8f2";
        };
      };

      cursor.style = {
        shape = "Beam";
        blinking = "On";
      };

      mouse.hide_when_typing = true;
    };
  };
}
