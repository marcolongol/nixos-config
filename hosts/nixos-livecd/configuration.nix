# Live CD/Image Configuration
# Configuration for generating bootable images and cloud images
{ lib, pkgs, hostname, ... }:

{
  system.stateVersion = "25.11";

  networking.hostName = hostname;

  # Disable impermanence for live images - we don't want persistence here
  environment.persistence."/persist".enable = lib.mkForce false;

  # Basic filesystem configuration for images
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  # Boot configuration for images - can be overridden by specific formats
  boot.loader.grub.enable = lib.mkDefault true;
  boot.loader.grub.device =
    lib.mkOverride 1200 "nodev"; # Lower priority than format configs
  boot.loader.grub.efiSupport = lib.mkDefault true;
  boot.loader.grub.efiInstallAsRemovable = lib.mkDefault true;
  boot.loader.systemd-boot.enable = lib.mkDefault false;

  # Image-specific overrides for installation and cloud environments
  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

  # Better for installation media - allow passwordless root initially
  users.users.root.password = lib.mkDefault "";
  users.users.root.hashedPassword = lib.mkForce null;

  # Networking for various environments
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = lib.mkDefault true;

  # Resize filesystem on first boot (useful for cloud images)
  boot.growPartition = lib.mkDefault true;

  # Console settings for better compatibility
  console = {
    keyMap = lib.mkDefault "us";
    font = lib.mkDefault "Lat2-Terminus16";
  };

  # Timezone (can be overridden by cloud-init)
  time.timeZone = lib.mkDefault "UTC";

  # Helpful packages for live environments
  environment.systemPackages = with pkgs; [
    # Installation tools
    parted
    gptfdisk
    cryptsetup

    # Network tools
    wget
    curl

    # Text editors
    vim
    nano

    # System tools
    lshw
    usbutils
    pciutils
  ];

  # Enable guest additions and drivers for VMs
  virtualisation.vmware.guest.enable = lib.mkDefault true;
  virtualisation.virtualbox.guest.enable = lib.mkDefault true;

  # Disable some services that aren't needed for images
  systemd.services.NetworkManager-wait-online.enable = lib.mkDefault false;

  # Better defaults for images
  services.logind.lidSwitch = lib.mkDefault "ignore";
}
