{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # =========================================================================
    # Core utilities (replaces gnu tools from Brewfile)
    # =========================================================================
    coreutils
    findutils
    gnused
    gnutar
    gawk
    gnugrep
    gnumake
    indent  # gnu-indent

    # =========================================================================
    # Shell
    # =========================================================================
    zsh
    bash

    # =========================================================================
    # Version control
    # =========================================================================
    git
    git-crypt
    gh
    tig
    bfg-repo-cleaner
    delta  # Better git diff

    # =========================================================================
    # Build tools & compilers
    # =========================================================================
    cmake
    autoconf
    autoconf-archive
    automake
    libtool
    pkg-config
    gcc
    # binutils - included with gcc

    # =========================================================================
    # Languages & runtimes
    # =========================================================================
    python3
    uv  # Fast Python package installer & resolver
    go
    rustup
    nodejs
    ruby
    chruby
    perl
    luajit  # provides lua, don't install both

    # =========================================================================
    # Security & encryption
    # =========================================================================
    gnupg
    pinentry_mac
    openssl
    age
    sops
    mkcert  # Local CA for dev HTTPS
    libyubikey
    yubikey-personalization  # ykpers
    kanidm_1_8  # Identity management

    # =========================================================================
    # Networking & web
    # =========================================================================
    curl
    wget
    httpie
    nmap
    autossh
    mtr
    bandwhich
    links2  # text browser
    w3m     # text browser

    # =========================================================================
    # Search & navigation
    # =========================================================================
    ripgrep
    fd
    fzf
    tree
    pstree
    eza       # Modern ls
    zoxide    # Smart cd
    bat       # Better cat
    sd        # Better sed
    ack
    silver-searcher  # ag
    peco

    # =========================================================================
    # Process & system monitoring
    # =========================================================================
    htop
    btop
    procs   # Better ps
    bottom  # System monitor

    # =========================================================================
    # Cloud & infrastructure
    # =========================================================================
    awscli2
    s3cmd
    google-cloud-sdk
    terraform
    kubectl
    k9s

    # =========================================================================
    # Text processing
    # =========================================================================
    jq
    yq
    pandoc
    ispell
    ctags

    # =========================================================================
    # External flakes
    # =========================================================================
    inputs.qmd.packages.${pkgs.system}.default

    # =========================================================================
    # Media & graphics
    # =========================================================================
    ffmpeg
    imagemagick
    graphviz
    yt-dlp

    # =========================================================================
    # Email & communication (uncomment if needed)
    # =========================================================================
    # msmtp
    # isync
    # mu
    # notmuch
    # neomutt
    weechat

    # =========================================================================
    # Terminal & multiplexing
    # =========================================================================
    # tmux managed by programs.tmux
    terminal-notifier

    # =========================================================================
    # Development utilities
    # =========================================================================
    direnv
    entr
    watch
    shellcheck
    nixpkgs-fmt
    nil  # Nix LSP

    # =========================================================================
    # Archiving & compression
    # =========================================================================
    unzip
    unar      # The Unarchiver
    unrar
    p7zip
    xz
    lzip
    zstd

    # =========================================================================
    # DNS & networking tools
    # =========================================================================
    dnsmasq
    proxychains-ng

    # =========================================================================
    # Backup & sync
    # =========================================================================
    rclone
    borgbackup

    # =========================================================================
    # Password management
    # =========================================================================
    gopass

    # =========================================================================
    # Libraries (usually auto-installed, but explicit for completeness)
    # =========================================================================
    readline
    sqlite
    libxml2
    pcre
    oniguruma
    libyaml

    # =========================================================================
    # Fonts (Nerd Fonts)
    # =========================================================================
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];

  fonts.fontconfig.enable = true;
}
