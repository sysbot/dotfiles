{ pkgs, ... }:
{

  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;
  # # Installs a version of nix, that dosen't need "experimental-features = nix-command flakes" in /etc/nix/nix.conf
  # services.nix-daemon.package = pkgs.nixFlakes;

  # if you use zsh (the default on new macOS installations),
  # you'll need to enable this so nix-darwin creates a zshrc sourcing needed environment changes
  programs.zsh.enable = true;
  # bash is enabled by default
  # home-manager.useGlobalPkgs = true;
  # home-manager.useUserPackages = true;
  # home-manager.users.bao = { pkgs, ... }: {
  #   home.stateVersion = "22.05";
  #   programs.tmux = { # my tmux configuration, for example
  #     enable = true;
  #     keyMode = "vi";
  #     clock24 = true;
  #     historyLimit = 10000;
  #     plugins = with pkgs.tmuxPlugins; [
  #       vim-tmux-navigator
  #       gruvbox
  #     ];
  #     extraConfig = ''
  #       new-session -s main
  #       bind-key -n C-a send-prefix
  #     '';
  #   };
  # };
  # hosts/YourHostName/default.nix - inside the returning attribute set
  homebrew = {
    enable = true;
    # autoUpdate = true;
    # updates homebrew packages on activation,
    # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
    casks = [
      # "hammerspoon"
      # "amethyst"
      # "alfred"
      # "logseq"
      "discord"
      # "iina"
    ];
  };

  system.defaults.dock.autohide = true;

}
