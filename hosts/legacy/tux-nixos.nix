# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [ ];

  nixpkgs.config.allowUnfreePredicate = (pkg: builtins.elem (lib.getName pkg) [
    "hplip"
    "zerotierone"
  ]);
  nix.autoOptimiseStore = true;
  nix.buildCores = 1;

  security.chromiumSuidSandbox.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" "ntfs" "btrfs" "exfat" "avfs" ];
  boot.cleanTmpDir = true;

  hardware.enableRedistributableFirmware = true;
  # networking.enableRalinkFirmware = true;

  networking.hostName = "tux-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s20u3u1.useDHCP = true;
  networking.interfaces.enp5s0f2.useDHCP = true;
  networking.interfaces.wlp0s20u6.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;
  networking.hostId = "21025bb1";
  networking.networkmanager.enable = true;
  networking.extraHosts = ''
    # 127.0.0.1 versions.teamspeak.com files.teamspeak-services.com
  '';

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    # consoleFont = "Lat2-Terminus16";
    # consoleKeyMap = "de";
    defaultLocale = "en_US.UTF-8";
  };

  console.font = "Lat2-Terminus16";
  console.keyMap = "de";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ virt-manager ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.zerotierone.enable = true;
  services.zerotierone.joinNetworks = [ "8286ac0e4768c8ae" ];

  services.pgmanage.enable = true;
  services.pgmanage.connections.k3s-hosted = "hostaddr=127.0.0.1 port=30432 dbname=postgres";
  
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  services.fwupd.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin ];

  services.ratbagd.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };
  hardware.bluetooth.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "de";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.windowManager.awesome.enable = true;

  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666"
  '';

  services.transmission.enable = true;

  services.zfs = {
    trim.enable = false;
    autoScrub.enable = true;
    autoSnapshot = {
      enable = true;
      flags = "-k -p -u";
      frequent = 6 * 4; # 6 hours!
      hourly = 12;
      daily = 3;
      weekly = 4;
      monthly = 2;
    };
  };

  programs = {
    # steam.enable = true;
    zsh.enable = true;
    zsh.enableCompletion = false;
  };

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "zfs";
    };

    containers.enable = true;

    libvirtd.enable = true;
    virtualbox.host.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };
  users.users = {
    nmelzer = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "wheel"
        "audio"
        "networkmanager"
        "vboxusers"
        "libvirtd"
        "docker"
        "transmission"
      ];
    };

    aroemer = {
      isNormalUser = true;
      extraGroups = [ ];
    };
  };

  security.sudo.extraRules = [
    {
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
      groups = [ "wheel" ];
    }
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
