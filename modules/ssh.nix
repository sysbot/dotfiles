{ config, lib, ... }:

let
  # Template definitions (equivalent to assh templates)
  templates = {
    n4n = {
      identityFile = "~/.ssh/key_personal";
      forwardAgent = true;
      user = "bao";
      port = 22;
      extraOptions.UserKnownHostsFile = "~/.ssh/n4n_hosts";
    };

    ary = {
      identityFile = "~/.ssh/key_personal";
      forwardAgent = true;
      user = "bao";
      port = 222;
      extraOptions.UserKnownHostsFile = "~/.ssh/ary_hosts";
    };

    nvidia = {
      user = "baon";
      port = 22;
      forwardAgent = true;
      extraOptions = {
        CanonicalizeHostname = "yes";
        CanonicalDomains = "nvidia.com";
        UserKnownHostsFile = "~/.ssh/nvidia_hosts";
      };
      identityFile = "~/.ssh/key_nvidia";
    };

    nvidiaCompressed = templates.nvidia // {
      compression = true;
    };

    av2Host = templates.nvidiaCompressed // {
      extraOptions = templates.nvidiaCompressed.extraOptions // {
        CanonicalDomains = "av2.bm.infra.nvda.ai";
      };
    };

    av3Host = templates.nvidiaCompressed // {
      extraOptions = templates.nvidiaCompressed.extraOptions // {
        CanonicalDomains = "av3.bm.infra.nvda.ai";
      };
    };

    av4Host = templates.nvidiaCompressed // {
      extraOptions = templates.nvidiaCompressed.extraOptions // {
        CanonicalDomains = "av4.bm.infra.nvda.ai";
      };
    };

    ngc = templates.nvidiaCompressed // {
      extraOptions = templates.nvidiaCompressed.extraOptions // {
        CanonicalDomains = "";  # No specific domain
      };
    };

    caffeineAws = {
      port = 22;
      forwardAgent = true;
      extraOptions.UserKnownHostsFile = "~/.ssh/caffeine_aws_hosts";
    };
  };

in
{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    compression = true;
    serverAliveInterval = 600;
    controlMaster = "auto";
    controlPath = "~/tmp/.ssh/cm/%h-%p-%r.sock";
    controlPersist = "yes";

    extraConfig = ''
      # Global defaults
      Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
      HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,ssh-rsa,ecdsa-sha2-nistp521-cert-v01@openssh.com,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp521,ecdsa-sha2-nistp384,ecdsa-sha2-nistp256
      KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256
      MACs hmac-sha2-256,hmac-sha2-512,hmac-sha1
      SendEnv LANG LC_*
      HashKnownHosts no
      ForwardX11 no

      # macOS keychain integration
      UseKeychain yes
      IgnoreUnknown UseKeychain
    '';

    matchBlocks = {
      # Default for all hosts
      "*" = {
        identityFile = "~/.ssh/key_personal";
        extraOptions = {
          AddKeysToAgent = "yes";
          StrictHostKeyChecking = "no";
        };
      };

      # ===== Personal Infrastructure (n4n) =====
      "svc1" = templates.n4n // { hostname = "192.168.12.30"; };
      "infra1" = templates.n4n // { hostname = "192.168.12.60"; };
      "core1" = templates.n4n // { hostname = "192.168.12.61"; };
      "core2" = templates.n4n // { hostname = "192.168.12.62"; };
      "tenant1" = templates.n4n // { hostname = "192.168.12.71"; };
      "tenant2" = templates.n4n // { hostname = "192.168.12.72"; };

      # Direct IP access to infra hosts (for nix remote builder, etc.)
      "192.168.12.*" = templates.n4n // {
        hostname = "%h";
      };

      # ===== ary.network hosts =====
      "bin.ary.network" = templates.ary // { hostname = "45.43.21.248"; };
      "tri.ary.network" = templates.ary // {
        hostname = "104.245.98.91";
        port = 22;  # Override template's 222
      };

      # ===== GitHub =====
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/key_personal";
        identitiesOnly = true;
      };

      # ===== NVIDIA Git Services =====
      "gitlab-master.nvidia.com" = {
        user = "git";
        port = 12051;
        forwardAgent = true;
        identityFile = "~/.ssh/key_05052025";
      };

      "git-mirror-santaclara.nvidia.com" = {
        user = "baon";
        port = 12013;
        forwardAgent = false;
        identitiesOnly = true;
        identityFile = "~/.ssh/key_20260114";
        extraOptions.IdentityAgent = "none";
      };

      "git-av.nvidia.com" = {
        user = "baon";
        port = 12013;
        forwardAgent = false;
        identitiesOnly = true;
        identityFile = "~/.ssh/key_20260114";
        extraOptions.IdentityAgent = "none";
      };

      "git.nvda.ai" = templates.nvidia // {
        user = "baon";
        port = 29418;
        forwardAgent = true;
      };

      # ===== NVIDIA Jumphosts =====
      "av2-jumphost" = templates.av2Host // {
        hostname = "10.180.16.117";
      };

      "av3-jumphost" = templates.av3Host // {
        hostname = "10.150.124.179";
      };

      "av4-jumphost" = templates.av4Host // {
        hostname = "10.217.3.178";
      };

      "sjc3-jumphost" = templates.ngc // {
        hostname = "jh3.av3.vm.infra.nvda.ai";
      };

      "sjc4-jumphost" = templates.ngc // {
        hostname = "jh3.av3.vm.infra.nvda.ai";
      };

      "sjc4-ngc-jumphost" = templates.ngc // {
        hostname = "24.51.7.4";
      };

      "sjc4-primary-ngc-jumphost" = templates.ngc // {
        hostname = "24.51.7.3";
      };

      "sjc3-ngc-jumphost" = templates.ngc // {
        hostname = "24.51.5.8";
      };

      "sjc11-bouncer" = templates.ngc // {
        hostname = "24.51.5.8";
      };

      # ===== NVIDIA AV2 Hosts (via av2-jumphost) =====
      "*.av2.vm.infra.nvda.ai" = templates.av2Host // {
        proxyJump = "av2-jumphost";
        extraOptions = templates.av2Host.extraOptions // {
          CanonicalDomains = "av2.vm.infra.nvda.ai";
          CanonicalizeFallbackLocal = "yes";
        };
      };

      "*.av2.bm.infra.nvda.ai" = templates.av2Host // {
        proxyJump = "av2-jumphost";
      };

      # ===== NVIDIA AV3 Hosts (via av3-jumphost) =====
      "dt2" = templates.av3Host // {
        hostname = "dt2.av3.vm.infra.nvda.ai";
        proxyJump = "av3-jumphost";
      };

      "*.av3.vm.infra.nvda.ai" = templates.av3Host // {
        proxyJump = "av3-jumphost";
        extraOptions = templates.av3Host.extraOptions // {
          CanonicalDomains = "av3.vm.infra.nvda.ai";
        };
      };

      "*.av3.bm.infra.nvda.ai" = templates.av3Host // {
        proxyJump = "av3-jumphost";
      };

      # ===== NVIDIA AV4/AV5 Hosts (via av4-jumphost) =====
      "*.av4.vm.infra.nvda.ai" = templates.av4Host // {
        proxyJump = "av4-jumphost";
        extraOptions = templates.av4Host.extraOptions // {
          CanonicalDomains = "av4.vm.infra.nvda.ai";
        };
      };

      "*.av4.bm.infra.nvda.ai" = templates.av4Host // {
        proxyJump = "av4-jumphost";
      };

      "*.av5.vm.infra.nvda.ai" = templates.av4Host // {
        proxyJump = "av4-jumphost";
        extraOptions = templates.av4Host.extraOptions // {
          CanonicalDomains = "av5.vm.infra.nvda.ai";
        };
      };

      "*.av5.bm.infra.nvda.ai" = templates.av4Host // {
        proxyJump = "av4-jumphost";
      };

      "10.52.134.198" = templates.av4Host // {
        proxyJump = "av4-jumphost";
      };

      # ===== NVIDIA SJC Hosts =====
      "*.sjc3.bm.infra.nvda.ai" = templates.ngc // {
        proxyJump = "sjc3-jumphost";
      };

      "*.sjc4.bm.infra.nvda.ai" = templates.ngc // {
        proxyJump = "sjc4-jumphost";
      };

      "*.sjc11.bm.infra.nvda.ai" = templates.ngc // {
        proxyJump = "sjc3-ngc-jumphost";
      };

      # ===== NGC Metal Hosts =====
      "*.nsv.sjc4.nvmetal.net" = templates.ngc // {
        proxyJump = "sjc4-ngc-jumphost";
        requestTTY = "yes";
      };

      "*.nsv.sjc11.nvmetal.net" = templates.ngc // {
        proxyJump = "sjc4-ngc-jumphost";
        requestTTY = "yes";
      };

      # ===== AWS Bastions =====
      "aws-bastion" = templates.caffeineAws // {
        hostname = "54.245.160.187";
      };

      "aws-staging-bastion" = templates.caffeineAws // {
        hostname = "35.155.204.70";
      };

      # ===== Fastly Bastion =====
      "bastion-slsjc1" = {
        hostname = "bastion-slsjc1.hosts.fastly.net";
        user = "bao";
        identityFile = "~/.ssh/key_fastly";
        extraOptions = {
          Tunnel = "no";
          UserKnownHostsFile = "~/.ssh/work_hosts";
        };
      };
    };
  };

  # Ensure control socket directory exists
  home.file."tmp/.ssh/cm/.keep".text = "";
}
