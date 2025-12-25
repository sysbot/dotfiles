{ pkgs, ... }:

{
  # Nix configuration
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "bao" ];
    };
  };

  # Enable nix-darwin
  services.nix-daemon.enable = true;

  # System packages (available system-wide)
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  # Shells
  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
  ];

  # macOS system preferences
  system.defaults = {
    # Dock
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.5;
      minimize-to-application = true;
      show-recents = false;
      static-only = false;
      tilesize = 48;
    };

    # Finder
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";  # List view
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    # Global
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
    };

    # Trackpad
    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
    };

    # Login window
    loginwindow = {
      GuestEnabled = false;
    };
  };

  # Keyboard
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  # Touch ID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # Homebrew (for casks that aren't in nixpkgs)
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
    };
    taps = [
      "tw93/tap"
    ];
    brews = [
      "mole"
    ];
    casks = [
      "docker"
      "google-chrome"
      "spotify"
      "vlc"
      "discord"
      "slack"
      "1password"
    ];
  };

  # System state version
  system.stateVersion = 4;
}
