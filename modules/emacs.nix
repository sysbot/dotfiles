{ pkgs, ... }:

let
  # emacs-macport 29.4 with native compilation and tree-sitter
  # Equivalent to: brew install emacs-mac --with-modules --with-native-compilation
  #                --with-mac-metal --with-tree-sitter
  #
  # Apply .override first (for build options), then .overrideAttrs (for source)
  myEmacs = (pkgs.emacs-macport.override {
    withNativeCompilation = true;
    withTreeSitter = true;
  }).overrideAttrs (old: rec {
    version = "29.4";
    src = pkgs.fetchurl {
      url = "https://bitbucket.org/mituharu/emacs-mac/get/emacs-${version}-mac-10.1.tar.gz";
      hash = "sha256-yWd1YGuKYp6utVGtmf9Ib8Qs1CsMCQcfP+9HEsEW2Dc=";
    };
  });
in
{
  home.packages = [
    myEmacs

    # Dependencies for Doom Emacs
    pkgs.sqlite  # For org-roam
  ];

  # Set EMACS environment variable for Doom
  home.sessionVariables = {
    EMACS = "${myEmacs}/bin/emacs";
  };
}
