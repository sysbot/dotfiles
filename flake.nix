{
  description = "Bao's dotfiles managed by Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-darwin for macOS system configuration
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Emacs overlay for emacs-macport (emacs-mac equivalent)
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # qmd - Quick Markdown Search
    qmd = {
      url = "github:tobi/qmd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ inputs.emacs-overlay.overlays.default ];
      };
    in
    {
      # Standalone Home Manager configuration
      # Usage: home-manager switch --flake .#bao
      homeConfigurations."bao" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit inputs; };
      };

      # nix-darwin + Home Manager (full macOS integration)
      # Usage: darwin-rebuild switch --flake .#macbook
      darwinConfigurations."macbook" = darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.bao = import ./home.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
            users.users.bao.home = "/Users/bao";
          }
        ];
      };

      # Remote Mac (baon-zero-3) with username "baon"
      # Usage: darwin-rebuild switch --flake .#baon-zero
      darwinConfigurations."baon-zero" = darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { primaryUser = "baon"; };
        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            # Disable nix-darwin nix management for Determinate Nix
            nix.enable = false;

            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.baon = import ./home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              username = "baon";
              homeDirectory = "/Users/baon";
            };
            users.users.baon.home = "/Users/baon";
          }
        ];
      };

      # Development shell
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nil  # Nix LSP
          nixpkgs-fmt  # Nix formatter
        ];
      };
    };
}
