{
  description = "My first nix flake";

  # XXX guide
  # https://xyno.space/post/nix-darwin-introduction
  # and https://gist.github.com/sysbot/2a8147dc3994f27be6485f97f679a555

  # inputs = {
  #     nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-22.05-darwin";
  #     home-manager.url = "github:nix-community/home-manager";
  #     home-manager.inputs.nixpkgs.follows = "nixpkgs";
  #     # nix will normally use the nixpkgs defined in home-managers inputs, we only want one copy of nixpkgs though
  #     darwin.url = "github:lnl7/nix-darwin";
  #     darwin.inputs.nixpkgs.follows = "nixpkgs"; # ...
  # };

  # # add the inputs declared above to the argument attribute set
  # outputs = { self, nixpkgs, home-manager, darwin }: {
  #   # we want `nix-darwin` and not gnu hello, so the packages stuff can go
  #   #
  #   darwinConfigurations."tavmini" = darwin.lib.darwinSystem {
  #   # you can have multiple darwinConfigurations per flake, one per hostname

  #     system = "aarch64-darwin"; # "x86_64-darwin" if you're using a pre M1 mac
  #     modules = [
  #       home-manager.darwinModules.home-manager
  #       ./hosts/tavmini/default.nix
  #     ]; # will be important later
  #   };
  # };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Other sources
    comma = { url = github:Shopify/comma; flake = false; };

  };

  outputs = { self, darwin, nixpkgs, home-manager, ... }@inputs:
  let
    inherit (darwin.lib) darwinSystem;
    inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;
    nixpkgsConfig = {
      config = { allowUnfree = true; };
      overlays = attrValues self.overlays ++ singleton (
        # Sub in x86 version of packages that don't build on Apple Silicon yet
        final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          inherit (final.pkgs-x86)
            idris2
            nix-index
            niv
            purescript;
        })
      );
    };
  in
  {
    # My `nix-darwin` configs
    #

      darwinConfigurations."tavmini" = darwin.lib.darwinSystem {
      # you can have multiple darwinConfigurations per flake, one per hostname

        system = "aarch64-darwin"; # "x86_64-darwin" if you're using a pre M1 mac
        modules = [
          home-manager.darwinModules.home-manager
          ./hosts/tavmini/default.nix
        ]; # will be important later
      };
    # darwinConfigurations = rec {
    #   j-one = darwinSystem {
    #     system = "aarch64-darwin";
    #     modules = attrValues self.darwinModules ++ [
    #       # Main `nix-darwin` config
    #       ./configuration.nix
    #       # `home-manager` module
    #       home-manager.darwinModules.home-manager
    #       {
    #         nixpkgs = nixpkgsConfig;
    #         # `home-manager` config
    #         home-manager.useGlobalPkgs = true;
    #         home-manager.useUserPackages = true;
    #         home-manager.users.jun = import ./home.nix;
    #       }
    #     ];
    #   };
    # };
  };
}
