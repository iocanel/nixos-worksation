# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, fetchFromGithub, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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
    LC_TIME = "el_GR.UTF-8";
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.bash;
    users.iocanel = {
      isNormalUser = true;
      description = "Ioannis Canellos";
      extraGroups = [ "root" "wheel" "docker" "networkmanager" ];
      packages = with pkgs; [];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     stdenv # nixos build essentials
     bash
     zsh
     pass
     bash
     neovim
     emacs
     htop
     wget
     zoxide
     fzf
     ripgrep
     silver-searcher
     curl
     stow
     docker
     docker-machine-kvm2
     docker-compose
     kubectl
     k9s
     kubernetes-helm
     kind
     minikube
     sddm
     i3
     alacritty
     rxvt-unicode
     xterm
     firefox
     arandr
     nitrogen
     ffmpeg
     mpv
     gimp
     opencv
     audacity
     obs-studio
     wireshark
     networkmanagerapplet
     git
     gcc
     gnumake
     python312
     rustup
     gnuplot
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.zsh.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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
  system.stateVersion = "23.05"; # Did you read the comment?

  systemd = {
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
}
