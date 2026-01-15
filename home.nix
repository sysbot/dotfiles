{ config, pkgs, lib, username ? "bao", homeDirectory ? "/Users/bao", ... }:

{
  imports = [
    ./modules/packages.nix
    ./modules/git.nix
    ./modules/shell.nix
    ./modules/tmux.nix
    ./modules/terminals.nix
    ./modules/emacs.nix
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "24.05";
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # SSH with agent integration
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        extraOptions = {
          AddKeysToAgent = "yes";
          UseKeychain = "yes";
          IgnoreUnknown = "UseKeychain";
        };
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/key_personal";
        identitiesOnly = true;
      };
    };
  };

  # XDG directories
  xdg.enable = true;

  # Raw config files for programs without HM modules
  xdg.configFile = {
    # Kanidm client configuration
    "kanidm" = {
      text = ''
        uri = "https://auth.tunas.n4n.dev"
        verify_ca = false
        verify_hostnames = false
      '';
    };
  };

  # Encrypted directories - managed manually (git-crypt encrypted, not tracked in flake)
  # home.file = {
  #   ".ssh" = {
  #     source = ./dotssh;
  #     recursive = true;
  #   };
  #   ".password-store" = {
  #     source = ./dotpassword-store;
  #     recursive = true;
  #   };
  # };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "emacsclient -t";
    VISUAL = "emacsclient -c";
    LANG = "en_US.UTF-8";
  };

  # macOS-specific settings
  targets.darwin.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };
  };
}
