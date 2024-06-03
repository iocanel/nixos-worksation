#
# My NixOS configuration
#

#
# Requirements:
#
# 1. nix-ld:
#
#    $ sudo nix-channel --add https://github.com/Mic92/nix-ld/archive/main.tar.gz nix-ld
#    $ sudo nix-channel --update
#
# 2. home manager
#    $ nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
#    $ nix-channel --update
# 


{ config, pkgs, fetchFromGithub, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      <nix-ld/modules/nix-ld.nix>
      <home-manager/nixos>
    ];

  # NIX_LD
  programs.nix-ld.dev.enable = true;


  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  #boot.loader.systemd-boot.enable = false;

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable networkd
  networking.useNetworkd = true;

  # Set your time zone.
  time.timeZone = "Europe/Athens";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "el_GR.UTF-8";
    LC_IDENTIFICATION = "el_GR.UTF-8";
    LC_MEASUREMENT = "el_GR.UTF-8";
    LC_MONETARY = "el_GR.UTF-8";
    LC_NAME = "el_GR.UTF-8";
    LC_NUMERIC = "el_GR.UTF-8";
    LC_PAPER = "el_GR.UTF-8";
    LC_TELEPHONE = "el_GR.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    enable=true;
    desktopManager = {
      xterm.enable = true;
    };
    displayManager = {
      defaultSession = "none+i3";
      sddm = {
        enable = true;
      };
      gdm = {
      	enable = false;
      };
    };
    windowManager = {
      i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
	  rofi
	  i3lock
	  i3blocks
        ];
      };
    };
    layout = "us,gr";
    xkbVariant = "";
    xkbOptions = "grp:alt_shift_toggle";
  };

  # Clipmenu
  services.clipmenu.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users.iocanel = {
      isNormalUser = true;
      description = "Ioannis Canellos";
      extraGroups = [ "root" "wheel" "audio" "docker" "networkmanager" ];
      packages = with pkgs; [
        zulip
	slack
	discord
	maven
	gradle
	temurin-bin-17
	nodejs
        python312
	rustup
	go
      ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Overlays
   nixpkgs.overlays = [
    (import /etc/nixos/overlays/custom-java-overlay.nix)
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     stdenv # nixos build essentials
     glibc
     bash
     zsh
     fish
     direnv
     pass
     pinentry-curses
     neovim
     emacs
     htop
     zoxide
     fzf
     ripgrep
     silver-searcher
     stow
     ollama
     clipmenu
     clipnotify
     xclip
     xsel
     #
     # Containers
     #
     docker
     docker-machine-kvm2
     docker-compose
     #
     # Kubernetes
     #
     kubectl
     k9s
     kubernetes-helm
     kind
     minikube
     #
     # Desktop environments
     #
     sddm
     i3
     i3blocks
     alacritty
     rxvt-unicode
     xterm
     arandr
     #
     # Audio, Video and Image
     #
     pulseaudio
     pavucontrol
     pa_applet
     nitrogen
     ffmpeg
     mpv
     gimp
     opencv
     audacity
     obs-studio
     #
     # Network and Internet
     #
     wget
     curl
     firefox
     chromium
     wireshark
     networkmanagerapplet
     #
     # Development
     #
     git
     gcc
     gnumake
     gnuplot
     #
     # Fonts
     #
     font-awesome
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "curses";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
	vi = "nvim";
    	update = "sudo nixos-rebuild switch";
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  #
  # Audio
  #
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  #
  # Printing
  #

  # Enable printing via CUPS
  services.printing.enable = true;
  # Run the avahi daemon
  services.avahi.enable = true;
  # Enable mDNS NSS plugin
  services.avahi.nssmdns = true;
  # Open the firewall for UDP port 5354
  services.avahi.openFirewall = true;


  #
  # Virtualisation
  #
  virtualisation.docker.enable=true;
  virtualisation.docker.storageDriver="overlay2";
 

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";

  systemd = {
    services = {
      fc-cache-update = {
        description = "Update font cache";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.fontconfig}/bin/fc-cache -fv'";
          RemainAfterExit = true;
        };
      };
    };
    network = {
      enable = true;
      netdevs = {
        br1 = {
	  netdevConfig = {
            Kind = "bridge";
	    Name = "br1";
	  };
        };
      };
      networks = {
        br1 = {
          matchConfig.Name = "br1";
          DHCP = "ipv4";
        };
	br1-bind = {
          matchConfig.Name = "en*";
	  networkConfig.Bridge="br1";
	};
      };
    };
  };
  
  #
  # Package activation
  #

  # Create a symlink for /bin/bash
  environment.etc."bash".source = "${pkgs.bash}/bin/bash";
  # Alternatively, use system activation script to create the symlink
  system.activationScripts.bash = {
    text = ''
      mkdir -p /bin
      ln -sf ${pkgs.bash}/bin/bash /bin/bash
    '';
  };
}

