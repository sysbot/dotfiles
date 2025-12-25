{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Bao Nguyen";
    userEmail = "baon@nvidia.com";

    signing = {
      key = "D57E947A";
      signByDefault = false;
    };

    aliases = {
      # Main branch helpers
      mainbranch = "!git remote show origin | sed -n '/HEAD branch/s/.*: //p'";
      synced = "!git pull origin $(git mainbranch) --rebase";
      update = "!git pull origin $(git rev-parse --abbrev-ref HEAD) --rebase";
      squash = "!git rebase -v -i $(git mainbranch)";
      publish = "push origin HEAD --force-with-lease";
      pub = "publish";

      # Basic shortcuts
      a = "add";
      amend = "commit --amend";
      au = "add -u .";
      ap = "add -p";
      br = "branch -v";
      bl = "blame";
      cl = "clean";
      clf = "clean --force";
      sh = "show";
      sb = "show-branch";
      ds = "diff --stat";
      ls = "ls-files";
      lo = "log";
      st = "status";
      co = "checkout";
      nb = "checkout -b";
      cp = "cherry-pick";
      ci = "commit";
      c = "commit -m";
      ca = "commit -am";
      d = "diff";
      rb = "rebase";
      rbc = "rebase --continue";
      rbs = "rebase --skip";
      rbi = "rebase --interactive";
      me = "merge";
      rs = "remote show";
      pu = "pull";
      pus = "submodule foreach git pull origin master";
      pur = "pull --recurse-submodules";
      pt = "push --tags";
      w = "whatchanged";
      dc = "diff --staged";
      sts = "status -s";
      rl = "reflog";
      ref = "reflog";
      rst = "reset";
      r = "remote";
      t = "tag";

      # Submodules
      sm = "submodule";
      sms = "submodule status";
      smi = "submodule init";
      smu = "submodule update";
      smf = "submodule foreach";

      # Remote
      rup = "remote update";
      rpr = "remote prune";
      pom = "push origin master";

      # Commit helpers
      cia = "commit -a";
      com = "!git checkout master && git pull";
      detach = "checkout HEAD^0";

      # Info & logs
      info = "config --list";
      summary = "log --pretty=oneline";
      sum = "log --oneline";
      rank = "shortlog -sn --no-merges";
      last = "log --oneline -10";
      tree = "log --graph --oneline --decorate";
      hist = "log --color --pretty=format:\"%C(yellow)%h%C(reset) %C(blue)[%an]%C(reset) %s%C(bold red)%d%C(reset) %C(green)%ad%C(reset)\" --relative-date --decorate";
      review = "log --stat=160,180 -p -w --patience --reverse -M -C -C -c";
      churn = "!git log --all -M -C --name-only --format='format:' \"$@\" | sort | grep -v '^$' | uniq -c | sort | awk 'BEGIN {print \"count\\tfile\"} {print $1 \"\\t\" $2}' | sort -g";

      # Savepoints & undo
      save = "!git add -A && git commit -m 'SAVEPOINT'";
      snapshot = "!git stash save \"snapshot: $(date)\" && git stash apply 'stash@{0}'";
      snapshots = "!git stash list --grep snapshot";
      undo = "reset HEAD~1 --mixed";
      wip = "!git add -u && git commit -m 'WIP'";
      wipe = "!git add -A && git commit -qm 'WIPE SAVEPOINT' && git reset HEAD~1 --hard";

      # Branch cleanup
      bclean = "!f() { git branch --merged \${1-master} | grep -v \" \${1-master}$\" | xargs -r git branch -d; }; f";
      bdone = "!f() { git checkout \${1-master} && git up && git bclean \${1-master}; }; f";

      # Conflict resolution
      ours = "!f() { git checkout --ours $@ && git add $@; }; f";
      theirs = "!f() { git checkout --theirs $@ && git add $@; }; f";

      # Update with submodules
      up = "!git pull --rebase --prune $@ && git submodule update --init --recursive";
    };

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.default = "upstream";
      fetch.recurseSubmodules = true;

      branch = {
        autosetuprebase = "always";
        autoSetupMerge = "always";
      };

      core = {
        editor = "emacsclient";
        pager = "delta";
        ignorecase = true;
        abbrev = 12;
        sparseCheckout = true;
        whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
      };

      diff = {
        algorithm = "patience";
        mnemonicprefix = true;
      };

      merge.conflictstyle = "zdiff3";
      rerere.enabled = true;

      color = {
        branch = "auto";
        diff = "auto";
        status = "auto";
        interactive = "auto";
        ui = true;
        pager = true;
      };

      "color \"diff\"".whitespace = "red reverse";
      apply.whitespace = "fix";
      commit.whitespace = "fix";
      pack = {
        threads = 0;
        useSparse = true;
      };

      credential.helper = "store";

      github = {
        user = "sysbot";
        site = "https://github.com";
        endpoint = "https://api.github.com";
      };

      "url \"git@github.com:\"".insteadOf = "https://github.com/";

      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        required = true;
        process = "git-lfs filter-process";
      };
    };

    delta = {
      enable = true;
      options = {
        navigate = true;
        dark = true;
        line-numbers = true;
        side-by-side = false;
      };
    };

    ignores = [
      ".DS_Store"
      "*.swp"
      "*.swo"
      "*~"
      ".direnv"
      ".envrc"
      "result"
      "result-*"
    ];

    lfs.enable = true;
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "emacsclient";
    };
  };
}
