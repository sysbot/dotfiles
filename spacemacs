;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load. If it is the symbol `all' instead
   ;; of a list then all discovered layers will be installed.
   dotspacemacs-configuration-layers
   '(
     go
     php
     graphviz
     javascript
     yaml
    elixir
    spacemacs-org
    (org :variables
         org-enable-github-support t
         org-enable-reveal-js-support t
         )
    nginx
    lua
    csv
    sql
    html
    ansible
    auto-completion
    better-defaults
    emacs-lisp
    git
    github
    markdown
    osx
    finance
    ruby
    latex
    (latex :variables latex-enable-auto-fill t)
    vagrant
    chrome
    python
    clojure

    extra-langs
    rust
    terraform
    ;; journal
    (shell :variables
          shell-default-height 30
          shell-default-position 'bottom)
    spell-checking
    plantuml
    ;; mu4e
    ;; (mu4e :variables mu4e-account-alist t)
    syntax-checking
    ; custom
    ;; bao
    go
    )
  ; ess
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages '(
                                      ;; ;; virtualenvwrapper
                                      json-mode
                                      fill-column-indicator
                                      ;; graphviz-dot-mode
                                      ;; ;; protobuf-mode
                                      ido-completing-read+
                                      ;; flycheck
                                      ;; go-projectile
                                      )
   ;; A list of packages and/or extensions that will not be install and loaded.
   dotspacemacs-excluded-packages '()
   ;; If non-nil spacemacs will delete any orphan packages, i.e. packages that
   ;; are declared in a layer which is not a member of
   ;; the list `dotspacemacs-configuration-layers'. (default t)
   dotspacemacs-delete-orphan-packages t
   )
  )

(defun dotspacemacs/init ()
  "Initialization function.
  ;; This function is called at the very startup of Spacemacs initialization
  ;; before layers configuration.
  ;; You should not put any user code in there besides modifying the variable
  ;; values."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https nil
   ;; Ma ximum allowed time in seconds to contact an ELPA repository.
   dotspacemacs-elpa-timeout 5
   ;; If non nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. (default t)
   dotspacemacs-check-for-update t
   ;; One of `vim', `emacs' or `hybrid'. Evil is always enabled but if the
   ;; variable is `emacs' then the `holy-mode' is enabled at startup. `hybrid'
   ;; uses emacs key bindings for vim's insert mode, but otherwise leaves evil
   ;; unchanged. (default 'vim)
   dotspacemacs-editing-style 'vim
   ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'nil
   ;; List of items to show in the startup buffer. If nil it is disabled.
   ;; Possible values are: `recents' `bookmarks' `projects'.
   ;; (default '(recents projects))
   dotspacemacs-startup-lists '(recents projects)
   ;; Number of recent files to show in the startup buffer. Ignored if
   ;; `dotspacemacs-startup-lists' doesn't include `recents'. (default 5)
   dotspacemacs-startup-recent-list-size 5
   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(monokai
                         solarized-dark
                         spacemacs-dark
                         spacemacs-light
                         solarized-light
                         leuven
                         zenburn)
   ;; If non nil the cursor color matches the state color in GUI Emacs.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font. `powerline-scale' allows to quickly tweak the mode-line
   ;; size to make separators look not too crappy.
   ;;dotspacemacs-default-font '("Inconsolata for Powerline"
   dotspacemacs-default-font '("Inconsolata for Powerline"
                               :size 12
                               :weight normal
                               :width normal
                               :powerline-scale 1.0)
   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m)
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs C-i, TAB and C-m, RET.
   ;; Setting it to a non-nil value, allows for separate commands under <C-i>
   ;; and TAB or <C-m> and RET.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil
   ;; (Not implemented) dotspacemacs-distinguish-gui-ret nil
   ;; The command key used for Evil commands (ex-commands) and
   ;; Emacs commands (M-x).
   ;; By default the command key is `:' so ex-commands are executed like in Vim
   ;; with `:' and Emacs commands are executed with `<leader> :'.
   dotspacemacs-command-key ";"
   ;; If non nil `Y' is remapped to `y$'. (default t)
   dotspacemacs-remap-Y-to-y$ t
   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "std"
   ;; ;; If non nil the default layout name is displayed in the mode-line.
   ;; ;; (default nil)
   dotspacemacs-display-default-layout "std"
   ;; ;; If non nil then the last auto saved layouts are resume automatically upon
   ;; ;; start. (default nil)
   ; XXXXX: this is causing debugger to fail?!?!?!
   dotspacemacs-auto-resume-layouts t
   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location nil
   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5
   ;; If non nil then `ido' replaces `helm' for some commands. For now only
   ;; `find-files' (SPC f f), `find-spacemacs-file' (SPC f e s), and
   ;; `find-contrib-file' (SPC f e c) are replaced. (default nil)
   dotspacemacs-use-ido nil
   ;; If non nil, `helm' will try to minimize the space it uses. (default nil)
   dotspacemacs-helm-resize nil
   ;; if non nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil
   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content. (default nil)
   dotspacemacs-enable-paste-micro-state nil
   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4
   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t
   ;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90
   ;; If non nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols nil
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters the
   ;; point when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling nil
   ;; If non nil line numbers are turned on in all `prog-mode' and `text-mode'
   ;; derivatives. If set to `relative', also turns on relative line numbers.
   ;; (default nil)
   dotspacemacs-line-numbers nil
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil
   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all
   ;; If non nil advises quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   ;; (default '("ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil
   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed'to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup `changed
   )
  )

(defun dotspacemacs/user-init ()
;; "Initialization function for user code. It is called immediately after `dotspacemacs/init', before layer configuration
;; executes. This function is mostly useful for variables that need to be set
;; before packages are loaded. If you are unsure, you should try in setting them in
;; `dotspacemacs/user-config' first."
  (setq-default rust-enable-racer t)
)

(defun dotspacemacs/user-config ()
  ;; ;; fontify code in code blocks
  ;; (setq org-src-fontify-natively t)

  ;; ;; Delete inputenc and fontenc from the default packages.
  ;; (setq org-latex-default-packages-alist (delete '("AUTO" "inputenc" t)
  ;;                                                org-latex-default-packages-alist))
  ;; (setq org-latex-default-packages-alist (delete '("T1" "fontenc" t)
  ;;                                                org-latex-default-packages-alist))
  ;; ;; Add minted to the defaults packages to include when exporting.
  ;; ;; alternatively you can add these by customizing org-latex-packages-alist.
  ;; (add-to-list 'org-latex-packages-alist '("" "minted") ("" "fontspec")

  ;;              ;; Tell the latex export to use the minted package for source
  ;;              ;; code coloration.
  ;;              (setq org-latex-listings 'minted)

  ;;              ;; Let the exporter use the -shell-escape option to let latex
  ;;              ;; execute external programs.
  ;;              ;; This obviously and can be dangerous to activate!
  ;;              (setq org-latex-pdf-process
  ;;                    '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f")))
  ;; (projectile-global-mode 1)
  ;; (go-projectile-tools-add-path)
  ;; (setq gofmt-command (concat go-projectile-tools-path "/bin/goimports"))
  (custom-set-variables
   '(markdown-command "/usr/local/bin/pandoc"))

  (setq gofmt-command "goimports")
  (ac-config-default)
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)
    (exec-path-from-shell-copy-env "GOPATH"))
  (setq-default evil-escape-key-sequence "jk")
  (add-hook 'doc-view-mode-hook 'auto-revert-mode)
  (setq ediff-window-setup-function 'ediff-setup-windows-default)
  (add-hook 'after-init-hook #'global-flycheck-mode)

  (defun my-go-mode-hook ()
    (setq tab-width 2 indent-tabs-mode 1)
    ; eldoc shows the signature of the function at point in the status bar.
    (go-eldoc-setup)
    (local-set-key (kbd "M-.") #'godef-jump)
    (add-hook 'before-save-hook 'gofmt-before-save))

    ; extra keybindings from https://github.com/bbatsov/prelude/blob/master/modules/prelude-go.el
    ;; (let ((map go-mode-map))
    ;;   (define-key map (kbd "C-c a") 'go-test-current-project) ;; current package, really
    ;;   (define-key map (kbd "C-c m") 'go-test-current-file)
    ;;   (define-key map (kbd "C-c .") 'go-test-current-test)
    ;;   (define-key map (kbd "C-c b") 'go-run)))
  (add-hook 'go-mode-hook 'my-go-mode-hook)
  ;; (setq org-latex-inputenc-alist '(("utf8" . "utf8x")))
  ;; (define-coding-system-alias 'ascii 'us-ascii)
  ;; (setq create-lockfiles nil)
  ;; (setq split-height-threshold nil)
  ;; (setq split-width-threshold 0)
  ;; (setq org-journal-dir "~/repos/personal/journal/")
  ;; (setq mu4e-maildir "~/Mail"
  ;;       mu4e-get-mail-command "mbsync -a"
  ;;       mu4e-update-interval nil
  ;;       mu4e-compose-signature-auto-include nil
  ;;       mu4e-view-show-images t
  ;;       mu4e-change-filenames-when-moving t
  ;;       mu4e-html2text-command "/usr/local/bin/w3m -T text/html"
  ;;       mu4e-view-show-addresses t)
  ;; (setq mu4e-account-alist
  ;;       '(("personal"
  ;;          (mu4e-sent-messages-behavior delete)
  ;;          (mu4e-sent-folder "/personal/sent")
  ;;          (mu4e-drafts-folder "/personal/drafts")
  ;;          (mu4e-trash-folder "/personal/trash")
  ;;          (user-mail-address "ngqbao@gmail.com")
  ;;          (user-full-name "Bao Nguyen"))
  ;;         ("fastly"
  ;;          (mu4e-sent-messages-behavior sent)
  ;;          (mu4e-sent-folder "/fastly/sent")
  ;;          (mu4e-drafts-folder "/fastly/drafts")
  ;;          (mu4e-trash-folder "/fastly/trash")
  ;;          (user-mail-address "bao@fastly.com")
  ;;          (user-full-name "Bao Nguyen"))))
  ;; (mu4e/mail-account-reset)
  ;; (add-hook 'prog-mode-hook (lambda () (spacemacs/toggle-line-numbers-off)))

  ; use msmtp
  (setq message-send-mail-function 'message-send-mail-with-sendmail)
  (setq sendmail-program "/usr/local/bin/msmtp")
  ; tell msmtp to choose the SMTP server according to the from field in the outgoing email
  (setq message-sendmail-extra-arguments '("--read-envelope-from"))
  (setq message-sendmail-f-is-evil 't)

  ;; (setq mu4e-maildir-shortcuts
  ;;       '(("/personal/INBOX" . ?p)
  ;;         ("/fastly/INBOX" . ?f)))
  ;; (setq mu4e-bookmarks
  ;;       `(("maildir:/fastly/important AND flag:unread AND NOT flag:trashed" "Important and unread" ?u)
  ;;         ("date:today..now" "Today's" ?t)
  ;;         ("date:7d..now" "Last 7 days" ?w)
  ;;         ("mime:image/*" "with images" ?p)
  ;;         (,(mapconcat 'identity
  ;;                      (mapcar
  ;;                       (lambda (maildir)
  ;;                         (concat "maildir:" (car maildir)))
  ;;                       mu4e-maildir-shortcuts) " OR ")
  ;;          "All inboxes" ?i)))
  ;; (add-hook 'makefile-mode-hook
  ;;           (lambda ()
  ;;             (setq indent-tabs-mode t)
  ;;             (setq-default indent-tabs-mode t)
  ;;             (setq tab-width 2)))
  ;; (add-hook 'makefile-gmake-mode-hook
  ;;           (lambda ()
  ;;             (setq indent-tabs-mode t)
  ;;             (setq-default indent-tabs-mode t)
  ;;             (setq tab-width 2)))
  ;; (add-hook 'makefile-bsdmake-mode-hook
  ;;           (lambda ()
  ;;             (setq indent-tabs-mode t)
  ;;             (setq-default indent-tabs-mode t)
  ;;             (setq tab-width 2)))
  ;; (add-hook 'before-save-hook
  ;;           (lambda ()
  ;;             (if (member major-mode '(makefile-bsdmake-mode makefile-mode makefile-gmake-mode))
  ;;                 (tabify (point-min) (point-max))
  ;;               (untabify (point-min) (point-max)))))
  (global-git-commit-mode t)
  (defun magit-push-arguments-maybe-upstream (magit-push-popup-fun &rest args)
    "Enable --set-upstream switch if there isn't a current upstream."
    (let ((magit-push-arguments
           (if (magit-get-remote) magit-push-arguments
             (cons "--set-upstream" magit-push-arguments))))
      (apply magit-push-popup-fun args)))
  (advice-add 'magit-push-popup :around #'magit-push-arguments-maybe-upstream)
  ;; NOTE: requires ido-completing-read+
  (setq magit-completing-read-function #'magit-ido-completing-read)
  (defun git-checkout-master-pull ()
    (magit-run-git "checkout" "origin/master"))
    ;; (magit-pull-from-upstream)
    ;; (magit-rebase))
  (defun git-quick-commit()
    (interactive)
    (magit-stage-modified)
    (magit-commit-amend "--no-edit")
    (magit-push-current-to-upstream)
    )
  (spacemacs/set-leader-keys "om" 'git-checkout-master-pull)
  (spacemacs/set-leader-keys "oc" 'git-quick-commit)
  (add-hook 'doc-view-mode-hook 'auto-revert-mode)
  (setq magit-repository-directories '("~/work/", "~/g/src/github.com/sysbot"))
  (setq flycheck-check-syntax-automatically '(mode-enabled save))
;;   (setq flycheck-check-syntax-automatically '(mode-enabled save))
;; ;;   ;; skips 'vendor' directories and sets GO15VENDOREXPERIMENT=1
;;   (setq flycheck-gometalinter-vendor nil)
;;   ;; only show errors
;;   (setq flycheck-gometalinter-errors-only t)
;;   ;; only run fast linters
;;   (setq flycheck-gometalinter-fast t)
;;   ;; use in tests files
;;   (setq flycheck-gometalinter-test nil)
;;   ;; disable linters
;;   (setq flycheck-gometalinter-disable-linters '("gotype" "gocyclo"))
;;   ;; Only enable selected linters
;;   (setq flycheck-gometalinter-disable-all t)
;;   (setq flycheck-gometalinter-enable-linters '("golint"))
;;   ;; Set different deadline (default: 5s)
;;   (setq flycheck-gometalinter-deadline "10s")
  ;; (setq-default evil-escape-key-sequence "jk")
;;   (ac-config-default)
  (setq fill-column 80) ;; M-q should fill at 80 chars, not 75
;;   (venv-initialize-interactive-shells) ;; if you want interactive shell support
;;   (venv-initialize-eshell) ;; if you want eshell support
;;   (setq venv-location (expand-file-name "~/Virtualenvs/"))
  (require 'fill-column-indicator) ;; line indicating some edge column
;;   (setq powerline-default-separator 'arrow)
;;   (setq edit-server-url-major-mode-alist '(("github\\.com" . org-mode)))
;;   (add-hook 'edit-server-done-hook (lambda () (shell-command "open -a \"Google Chrome\"")))
;;   (global-hl-line-mode -1) ; Disable current line highlight
;;   (defun pull-request-url ()
;;     "Build the URL or the pull requestion on GitHub corresponding to the current branch. Uses Magit."
;;     (interactive)
;;     (format "%s/compare/%s"
;;             (replace-regexp-in-string
;;              (rx (and string-start (1+ any) "github.com:" (group (1+ any)) ".git" string-end))
;;              "https://github.com/\\1"
;;              (magit-get "remote" (magit-get-current-remote) "url"))
            ;; (magit-get-current-branch)))
  (setq org-directory (file-truename "~/repos/personal/org")
    ;; follow links by pressing ENTER on them
    org-return-follows-link t
    ;; allow changing between todo stats directly by hotkey
    org-use-fast-todo-selection t
    ;; syntax highlight code in source blocks
    org-src-fontify-natively t
    ;; for the leuven theme, fontify the whole heading line
    org-fontify-whole-heading-line t
    ;; force UTF-8
    org-export-coding-system 'utf-8
    ;; don't use ido completion (I use helm)
    org-completion-use-ido nil
    ;; start up org files with indentation (same as #+STARTUP: indent)
    org-startup-indented t
    ;; don't indent source code
    org-edit-src-content-indentation 0
    ;; don't adapt indentation
    org-adapt-indentation nil
    ;; preserve the indentation inside of source blocks
    org-src-preserve-indentation t
    ;; Imenu should use 3 depth instead of 2
    org-imenu-depth 3
    ;; put state change log messages into a drawer
    org-log-into-drawer t
    ;; special begin/end of line to skip tags and stars
    org-special-ctrl-a/e t
    ;; special keys for killing a headline
    org-special-ctrl-k t
    ;; don't adjust subtrees that I copy
    org-yank-adjusted-subtrees nil
    ;; try to be smart when editing hidden things
    org-catch-invisible-edits 'smart
    ;; blank lines are removed when exiting the code edit buffer
    org-src-strip-leading-and-trailing-blank-lines t
    ;; how org-src windows are set up when hitting C-c '
    org-src-window-setup 'current-window
    ;; Overwrite the current window with the agenda
    org-agenda-window-setup 'current-window
    ;; Use 100 chars for the agenda width
    org-agenda-tags-column -100
    ;; Use full outline paths for refile targets - we file directly with IDO
    org-refile-use-outline-path t
    ;; Targets complete directly with IDO
    org-outline-path-complete-in-steps nil
    ;; Allow refile to create parent tasks with confirmation
    org-refile-allow-creating-parent-nodes 'confirm
    ;; never leave empty lines in collapsed view
    org-cycle-separator-lines 0
    ;; Use cider as the clojure backend
    ;org-babel-clojure-backend 'cider
    ;; don't run stuff automatically on export
    ;org-export-babel-evaluate nil
    ;; export tables as CSV instead of tab-delineated
    org-table-export-default-format "orgtbl-to-csv"
    ;; start up showing images
    org-startup-with-inline-images t
    ;; always enable noweb, results as code and exporting both
    ; org-babel-default-header-args
    ; (cons '(:noweb . "yes")
    ;      (assq-delete-all :noweb org-babel-default-header-args))
    ; org-babel-default-header-args
    ;(cons '(:exports . "both")
    ;      (assq-delete-all :exports org-babel-default-header-args))
    ;; I don't want to be prompted on every code block evaluation
    ;org-confirm-babel-evaluate nil
    ;; Mark entries as done when archiving
    org-archive-mark-done t
    ;; Where to put headlines when archiving them
    org-archive-location "%s_archive::* Archived Tasks"
    ;; Sorting order for tasks on the agenda
    org-agenda-sorting-strategy
    '((agenda habit-down
              time-up
              priority-down
              user-defined-up
              effort-up
              category-keep)
      (todo priority-down category-up effort-up)
      (tags priority-down category-up effort-up)
      (search priority-down category-up))
    ;; Enable display of the time grid so we can see the marker for the
    ;; current time
    org-agenda-time-grid
    '((daily today remove-match)
      #("----------------" 0 16 (org-heading t))
      (0900 1100 1300 1500 1700))
    ;; keep the agenda filter until manually removed
    org-agenda-persistent-filter t
    ;; show all occurrences of repeating tasks
    org-agenda-repeating-timestamp-show-all t
    ;; always start the agenda on today
    org-agenda-start-on-weekday nil
    ;; Use sticky agenda's so they persist
    org-agenda-sticky t
    ;; show 4 agenda days
    org-agenda-span 4
    ;; Do not dim blocked tasks
    org-agenda-dim-blocked-tasks nil
    ;; Compact the block agenda view
    org-agenda-compact-blocks t
    ;; Show all agenda dates - even if they are empty
    org-agenda-show-all-dates t
    ;; Agenda org-mode files
    ;; TODO: broken
    ;; (defun ap/verify-refile-target ()
    ;;   "Exclude todo keywords with a done state from refile targets"
    ;;   (not (member (nth 2 (org-heading-components)) org-done-keywords)))

    ;; (setq org-refile-target-verify-function 'ap/verify-refile-target)
    )
(setq org-agenda-files `("~/repos/personal/org"))
;; (defun tav-capture-date-file (path)
;;   (expand-file-name (concat path (format-time-string "%Y%m%d%s") ".md")))

(defconst tav-recipes-dir "~/repos/recipes")
(defconst tav-recipes-files (concat tav-recipes-dir "/%Y%m%d.org"))
(setq-default org-download-image-dir "~/repos/recipes/images")

(setq org-capture-templates
      '(("t" "todo" entry (file+headline "~/repos/personal/org/todo.org" "Tasks")
         "* TODO [#A] %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%a\n")
        ("r" "recipe" plain (file (format-time-string tav-recipes-files))
         "* %?\nEntered on %U\n  %i\n  %a"
         :empty-lines 1
         )
        ("j" "journal" entry (file+datetree "~/repos/personal/org/journal.org")
         "* %?\nEntered on %U\n  %i\n  %a")
        ))

;; (setq org-todo-keywords
;;       (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
;;               (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "MEETING"))))
;; (setq org-todo-keyword-faces
;;       (quote (("TODO" :foreground "red" :weight bold)
;;               ("NEXT" :foreground "blue" :weight bold)
;;               ("DONE" :foreground "forest green" :weight bold)
;;               ("WAITING" :foreground "orange" :weight bold)
;;               ("HOLD" :foreground "magenta" :weight bold)
;;               ("CANCELLED" :foreground "forest green" :weight bold)
;;               ("MEETING" :foreground "forest green" :weight bold)
;;               )))

(setq org-agenda-custom-commands
      (quote (("N" "Notes" tags "NOTE"
               ((org-agenda-overriding-header "Notes")
                (org-tags-match-list-sublevels t)))
              ("h" "Habits" tags-todo "STYLE=\"habit\""
               ((org-agenda-overriding-header "Habits")
                (org-agenda-sorting-strategy
                 '(todo-state-down effort-up category-keep))))
              (" " "Agenda"
               ((agenda "" nil)
                (tags "REFILE"
                      ((org-agenda-overriding-header "Tasks to Refile")
                       (org-tags-match-list-sublevels nil)))
                (tags-todo "-CANCELLED/!"
                           ((org-agenda-overriding-header "Stuck Projects")
                            (org-agenda-skip-function 'bh/skip-non-stuck-projects)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags "-REFILE/"
                      ((org-agenda-overriding-header "Tasks to Archive")
                       (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
                       (org-tags-match-list-sublevels nil))))
               nil))))
    (org-babel-do-load-languages
     'org-babel-load-languages '((dot . t))) ; this line activates dot
(setq org-plantuml-jar-path (expand-file-name "~/repos/org/contrib/scripts/plantuml.jar"))
(org-babel-do-load-languages
 'org-babel-load-languages
 '(;; other Babel languages
   (plantuml . t)))



















)
;; ;; active Org-babel languages
;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '(;; other Babel languages
;;    (plantuml . t)))
;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((python . t)))
;;     )
;; ))

;; here goes your Org config :)
;; ....
;)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(sesman go-projectile go-rename go-autocomplete phpunit phpcbf php-extras php-auto-yasnippets drupal-mode php-mode hcl-mode haml-mode ham-mode html-to-markdown web-completion-data dash-functional inflections edn paredit peg cider seq queue clojure-mode rust-mode inf-ruby anaconda-mode pythonic auto-complete company tern skewer-mode simple-httpd yasnippet multiple-cursors js2-mode org-category-capture alert log4e gntp json-snatcher json-reformat memoize gitignore-mode gh marshal logito pcache ht flyspell-correct pos-tip flycheck magit magit-popup git-commit ghub let-alist with-editor packed powerline request pcre2el spinner org-plus-contrib hydra parent-mode projectile pkg-info epl flx smartparens iedit anzu evil goto-chg undo-tree eval-sexp-fu highlight f dash s diminish bind-map bind-key helm avy helm-core popup async markdown-mode go-mode define-word thrift stan-mode scad-mode qml-mode matlab-mode julia-mode protobuf-mode ox-reveal org-mime ob-elixir flycheck-mix flycheck-credo alchemist elixir-mode company-auctex auctex-latexmk auctex flycheck-gometalinter yapfify yaml-mode xterm-color ws-butler winum which-key web-mode web-beautify volatile-highlights virtualenvwrapper vi-tilde-fringe vagrant-tramp vagrant uuidgen use-package unfill toml-mode toc-org terraform-mode tagedit sql-indent spaceline smeargle slim-mode shell-pop scss-mode sass-mode rvm ruby-tools ruby-test-mode rubocop rspec-mode robe reveal-in-osx-finder restart-emacs rbenv rake rainbow-delimiters racer pyvenv pytest pyenv-mode py-isort pug-mode popwin plantuml-mode pip-requirements persp-mode pbcopy paradox ox-gfm osx-trash osx-dictionary orgit org-projectile org-present org-pomodoro org-journal org-download org-bullets open-junk-file nginx-mode neotree mwim multi-term mu4e-maildirs-extension mu4e-alert move-text monokai-theme mmm-mode minitest markdown-toc magit-gitflow magit-gh-pulls macrostep lua-mode lorem-ipsum livid-mode live-py-mode linum-relative link-hint less-css-mode ledger-mode launchctl json-mode js2-refactor js-doc jinja2-mode info+ indent-guide ido-completing-read+ hy-mode hungry-delete htmlize hl-todo highlight-parentheses highlight-numbers highlight-indentation hide-comnt help-fns+ helm-themes helm-swoop helm-pydoc helm-projectile helm-mode-manager helm-make helm-gitignore helm-flx helm-descbinds helm-css-scss helm-company helm-c-yasnippet helm-ag graphviz-dot-mode google-translate golden-ratio go-guru go-eldoc gnuplot gmail-message-mode github-search github-clone github-browse-file gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe git-gutter-fringe+ gist gh-md fuzzy flyspell-correct-helm flymd flycheck-rust flycheck-pos-tip flycheck-ledger flx-ido fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-ediff evil-args evil-anzu eshell-z eshell-prompt-extras esh-help emmet-mode elm-mode elisp-slime-nav edit-server dumb-jump diff-hl cython-mode csv-mode company-web company-tern company-statistics company-go company-ansible company-anaconda column-enforce-mode coffee-mode clojure-snippets clj-refactor clean-aindent-mode cider-eval-sexp-fu chruby cargo bundler auto-yasnippet auto-highlight-symbol auto-dictionary auto-compile arduino-mode ansible-doc ansible aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line ac-ispell))
 '(safe-local-variable-values
   '((org-download-image-dir . "./images")
     (elixir-enable-compilation-checking . t)
     (elixir-enable-compilation-checking))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((((class color) (min-colors 257)) (:foreground "#F8F8F2" :background "#272822")) (((class color) (min-colors 89)) (:foreground "#F5F5F5" :background "#1B1E1C")))))
