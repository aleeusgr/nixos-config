# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  boot.initrd.availableKernelModules = ["uhci_hcd" "ehci_pci" "ahci" "firewire_ohci" "usbhid" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci"];
  boot.initrd.kernelModules = ["dm-snapshot"];
  boot.kernelModules = ["kvm-intel" "wl"];
  boot.extraModulePackages = [];
  boot.supportedFilesystems = ["ntfs-3g"];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1be71104-48ad-40c3-bf4c-086cd887969f";
    fsType = "ext4";
  };

  # fileSystems."/nix/store" = {
  #   device = "/dev/disk/by-uuid/1ee9d669-07e1-4f40-93af-71f9ad999f70";
  #   fsType = "ext4";
  # };

  fileSystems."/nix/store" = {
    device = "/dev/mapper/pool-store--old";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/53a36eeb-9f0e-4cb6-bdd9-53ae5a74c683";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  swapDevices = [{device = "/dev/disk/by-uuid/87c5fea1-6bcb-41d4-af9d-b9342a45c9b3";}];

  nix.settings.max-jobs = lib.mkDefault 1;
}
