{ pkgs, config, lib, primaryUser ? "bao", ... }:

let
  homeDir = "/Users/${primaryUser}";
in
{
  # Primary user for user-specific settings
  system.primaryUser = primaryUser;

  # Nix configuration
  # Note: When using Determinate Nix, set nix.enable = false via specialArgs
  nix = {
    # Disable nix-darwin's nix management when using Determinate Nix
    enable = lib.mkDefault true;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" primaryUser ];
      # Use remote builder for x86_64-linux builds
      builders-use-substitutes = true;
    };

    # Remote builders for cross-platform builds
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "192.168.12.60";  # infra1
        sshUser = primaryUser;
        sshKey = "${homeDir}/.ssh/id_ed25519";
        system = "x86_64-linux";
        maxJobs = 4;
        speedFactor = 2;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      }
    ];

    # Garbage collection - runs weekly on Sunday at 3am
    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 3; Minute = 0; };
      options = "--delete-older-than 30d";
    };
    # Store optimization - runs daily at 4am (safe alternative to auto-optimise-store)
    optimise = {
      automatic = true;
      interval = { Hour = 4; Minute = 0; };
    };
  };

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
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
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

    # Screenshots
    screencapture = {
      location = "~/Screenshots";
      type = "png";
      disable-shadow = true;
    };

    # Screensaver
    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 0;
    };

    # Custom preferences
    CustomUserPreferences = {
      # Disable .DS_Store on network and USB drives
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      # Disable disk image verification
      "com.apple.frameworks.diskimages" = {
        skip-verify = true;
        skip-verify-locked = true;
        skip-verify-remote = true;
      };
      # Enable spring loading for directories
      "com.apple.finder" = {
        com.apple.springing.enabled = true;
        com.apple.springing.delay = 0.5;
      };
    };
  };

  # Keyboard
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  # Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Homebrew - disabled during switch, managed manually via ~/dotfiles/Brewfile
  # Run `brewsync` to install/update, or `brew bundle --file=~/dotfiles/Brewfile`
  homebrew.enable = false;

  # Launchd daemons (system-level)
  launchd.daemons.nosleep = {
    serviceConfig = {
      Label = "com.nosleep.system";
      ProgramArguments = [
        "/usr/bin/caffeinate"
        "-i"  # prevent idle sleep
        "-s"  # prevent system sleep on AC power
      ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };

  # Launchd services (user-level)
  # Note: Disabled for non-primary machines - the flake config name varies
  # launchd.user.agents.nix-flake-update = {
  #   serviceConfig = {
  #     ProgramArguments = [
  #       "/bin/sh"
  #       "-c"
  #       "cd ${homeDir}/dotfiles && /etc/profiles/per-user/${primaryUser}/bin/nix flake update && /run/current-system/sw/bin/darwin-rebuild switch --flake '.#macbook' 2>&1 | /usr/bin/logger -t nix-flake-update"
  #     ];
  #     StartCalendarInterval = [{ Weekday = 1; Hour = 9; Minute = 0; }];  # Monday 9am
  #     StandardErrorPath = "/tmp/nix-flake-update.err";
  #     StandardOutPath = "/tmp/nix-flake-update.out";
  #   };
  # };

  # Activation scripts
  system.activationScripts.postActivation.text = ''
    # Symlink emacsclient for org-protocol.app
    ln -sf /etc/profiles/per-user/${primaryUser}/bin/emacsclient /opt/homebrew/bin/emacsclient 2>/dev/null || true
    # Create Screenshots directory
    mkdir -p ${homeDir}/Screenshots
  '';

  # System state version
  system.stateVersion = 4;
}
