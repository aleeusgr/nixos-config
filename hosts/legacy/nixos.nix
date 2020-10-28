{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  users.users.demo =
    {
      isNormalUser = true;
      description = "Demo user account";
      extraGroups = [ "wheel" "docker" ];
      uid = 1000;
      shell = pkgs.zsh;
    };

  boot.kernel.sysctl = {
    "vm.max_map_count" = 262144;
  };

  programs.zsh.enable = true;

  nix.useSandbox = true;
  nix.autoOptimiseStore = true;

  virtualisation = {
    docker.enable = true;
    docker.extraOptions = "--insecure-registry registry.cap01.cloudseeds.de";
  };

  console.font = "Lat2-Terminus16";
  console.keyMap = "de";

  services.xserver.layout = pkgs.lib.mkForce "de";

  services.xserver.videoDrivers = [ "vmware" "virtualbox" "modesetting" ];
  systemd.services.virtualbox-resize = {
    description = "VirtualBox Guest Screen Resizing";

    wantedBy = [ "multi-user.target" ];
    requires = [ "dev-vboxguest.device" ];
    after = [ "dev-vboxguest.device" ];

    unitConfig.ConditionVirtualization = "oracle";

    serviceConfig.ExecStart = "@${config.boot.kernelPackages.virtualboxGuestAdditions}/bin/VBoxClient -fv --vmsvga";
  };

  services.zerotierone.enable = true;
  services.zerotierone.joinNetworks = [ "8286ac0e4768c8ae" ];

  # Mount a VirtualBox shared folder.
  # This is configurable in the VirtualBox menu at
  # Machine / Settings / Shared Folders.
  # fileSystems."/mnt" = {
  #   fsType = "vboxsf";
  #   device = "nameofdevicetomount";
  #   options = [ "rw" ];
  # };

  services.openssh.enable = true;

  swapDevices = [{
    device = "/var/swap-2";
    size = 2048 * 4;
  }];

  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "builder-zerotier";
      system = "x86_64-linux";
      maxJobs = 1;
      speedFactor = 1;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    }
  ];
}
