{ config, pkgs, lib, ... }:

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
    username = "bao";
    homeDirectory = "/Users/bao";
    stateVersion = "24.05";
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # XDG directories
  xdg.enable = true;

  # Raw config files for programs without HM modules
  xdg.configFile = {
    "ghostty/config".source = ./dotconfig/ghostty/config;
    "zed/settings.json".source = ./dotconfig/zed/settings.json;
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
