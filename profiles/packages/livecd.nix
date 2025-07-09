# Live CD/Image profile
# Configuration for live images, installation media, and cloud images
{ lib, pkgs, ... }: {

  # Disable impermanence for live images by overriding the base profile's persistence config
  environment.persistence."/persist" = lib.mkForce { };

  # Live image specific configurations
  services = {
    # Disable cloud-init by default for installation media
    # Cloud formats will override this with lib.mkForce true
    cloud-init.enable = lib.mkDefault false;

    # SSH configuration for live images
    openssh = {
      enable = lib.mkDefault true;
      settings = {
        PermitRootLogin = lib.mkForce "yes";
        PasswordAuthentication = lib.mkForce true;
        # Allow empty passwords for live images
        PermitEmptyPasswords = lib.mkDefault true;
      };
    };
  };

  # User configuration for live images
  users = {
    # Allow mutable users for live images
    mutableUsers = lib.mkDefault true;

    # Root user setup
    users.root = {
      password = lib.mkDefault "";
      hashedPassword = lib.mkForce null;
    };

    # Create a default live user if needed
    users.nixos = lib.mkDefault {
      isNormalUser = true;
      description = "NixOS Live User";
      extraGroups = [ "wheel" "networkmanager" ];
      password = "";
      hashedPassword = null;
    };
  };

  # Networking configuration
  networking = {
    useDHCP = lib.mkDefault true;
    networkmanager.enable = lib.mkDefault true;

    # Disable firewall for live images to avoid connectivity issues
    firewall.enable = lib.mkForce false;
  };

  # Boot configuration for live images
  boot = {
    # Enable filesystem resizing for cloud images
    growPartition = lib.mkDefault true;

    # Kernel parameters for better hardware support
    kernelParams = [
      "console=tty0" # Ensure output goes to display, not just serial
    ];

    # Boot loader timeout
    loader.timeout = lib.mkDefault 5;
  };

  # Security adjustments for live images
  security = {
    # Allow sudo without password for wheel group in live images
    sudo = { wheelNeedsPassword = lib.mkDefault false; };

    # Allow empty passwords for live images
    pam.services.su.allowNullPassword = lib.mkDefault true;
    pam.services.sudo.allowNullPassword = lib.mkDefault true;
  };

  # Additional packages useful for live images
  environment.systemPackages = with pkgs; [
    # Installation tools
    parted
    gptfdisk
    dosfstools

    # Network tools
    wget
    curl

    # Text editors
    nano
    vim

    # Hardware detection
    pciutils
    usbutils
    lshw

    # Disk utilities
    smartmontools
    hdparm
  ];

  # Enable hardware detection
  hardware = {
    enableAllFirmware = lib.mkDefault true;
    enableRedistributableFirmware = lib.mkDefault true;
  };

  # Documentation for live images
  documentation = {
    enable = lib.mkDefault true;
    nixos.enable = lib.mkDefault true;
  };

  # Automatic hardware configuration
  services.udev.extraRules = ''
    # Automatically load firmware
    SUBSYSTEM=="firmware", ACTION=="add", ATTR{loading}="-1"
  '';
}
