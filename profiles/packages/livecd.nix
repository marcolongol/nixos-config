# Live CD/Image profile
# Configuration for live images, installation media, and cloud images
{ lib, pkgs, config, ... }: {
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
        PubkeyAuthentication = lib.mkForce false;
        # Allow empty passwords for live images
        PermitEmptyPasswords = lib.mkForce true;
        # Be more permissive with auth attempts
        MaxAuthTries = lib.mkForce 6;
        # Force password authentication only
        AuthenticationMethods = lib.mkForce "password";
        # Disable other auth methods
        ChallengeResponseAuthentication = lib.mkForce false;
        UsePAM = lib.mkForce true;
      };
    };

    # Disable unnecessary services for live images to save memory
    printing.enable = lib.mkDefault false;
    avahi.enable = lib.mkDefault false;
  };

  # User configuration for live images
  users = {
    # Allow mutable users for live images
    mutableUsers = lib.mkDefault true;

    # Root user setup
    users.root = {
      hashedPassword = lib.mkForce null; # No password for root in live images
    };

    # Create a default live user if needed
    users.nixos = lib.mkDefault {
      isNormalUser = true;
      description = "NixOS Live User";
      extraGroups = [ "wheel" "networkmanager" "users" ];
      password = "";
      hashedPassword = null;
    };
  };

  # Disable firewall for live images to avoid connectivity issues
  networking.firewall.enable = lib.mkDefault false;

  # Boot configuration for live images
  boot = {
    # Boot loader configuration - can be overridden by specific formats
    loader = {
      grub = {
        enable = lib.mkDefault true;
        device =
          lib.mkOverride 1200 "nodev"; # Lower priority than format configs
        efiSupport = lib.mkDefault true;
        efiInstallAsRemovable = lib.mkDefault true;
      };
      systemd-boot.enable = lib.mkDefault false;
    };

    # Enable filesystem resizing for cloud images
    growPartition = lib.mkDefault true;

    # Plymouth splash screen configuration
    plymouth = {
      enable = lib.mkDefault true;
      theme = lib.mkDefault "breeze";
    };

    # Kernel parameters for better hardware support and splash
    kernelParams = [
      "console=tty0" # Ensure output goes to display, not just serial
      "quiet" # Reduce boot verbosity for better user experience
      "splash" # Enable splash screen if available
      "rd.udev.log_priority=3" # Reduce udev log verbosity
      "vt.global_cursor_default=0" # Hide cursor during boot
    ];

    # Boot loader timeout
    loader.timeout = lib.mkDefault 5;

    # Enable initrd SSH for remote debugging if needed
    initrd.network.enable = lib.mkDefault false;

    # Optimize tmpfs sizes for live images
    tmp = {
      useTmpfs = lib.mkDefault true;
      tmpfsSize = lib.mkDefault "50%"; # Use 50% of RAM for /tmp
    };
  };

  # Security adjustments for live images
  security = {
    # Allow sudo without password for wheel group in live images
    sudo = { wheelNeedsPassword = lib.mkDefault false; };

    # Allow empty passwords for live images
    pam.services.su.allowNullPassword = lib.mkDefault true;
    pam.services.sudo.allowNullPassword = lib.mkDefault true;
  };

  # Basic filesystem configuration for images
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  # Console settings for better compatibility
  console = {
    keyMap = lib.mkDefault "us";
    font = lib.mkDefault "Lat2-Terminus16";
  };

  # Timezone (can be overridden by cloud-init)
  time.timeZone = lib.mkDefault "UTC";

  # Enable guest additions and drivers for VMs
  virtualisation.vmware.guest.enable = lib.mkDefault true;
  virtualisation.virtualbox.guest.enable = lib.mkDefault true;

  # Better defaults for images
  services.logind.lidSwitch = lib.mkDefault "ignore";

  # Disable some services that aren't needed for images
  systemd.services.NetworkManager-wait-online.enable = lib.mkDefault false;

  # Additional packages useful for live images
  environment.systemPackages = with pkgs; [
    # Installation tools
    parted
    gptfdisk
    dosfstools
    ntfs3g
    exfatprogs

    # Network tools
    wget
    curl
    rsync
    openssh

    # Text editors
    nano
    vim

    # Hardware detection
    pciutils
    usbutils
    lshw
    hwinfo
    dmidecode

    # Disk utilities
    smartmontools
    hdparm

    # Compression tools
    zip
    unzip
    p7zip

    # System utilities
    htop
    iotop
    stress
    memtest86plus

    # Network utilities
    nmap
    iperf3
    tcpdump
    wireshark-cli

    # File system utilities
    btrfs-progs
    xfsprogs
    e2fsprogs

    # Recovery tools
    testdisk
    ddrescue

    # System tools for image diagnostics and hardware detection
    lshw
    usbutils
    pciutils
    cryptsetup
  ];

  # Enable hardware detection
  hardware = {
    enableAllFirmware = lib.mkDefault true;
    enableRedistributableFirmware = lib.mkDefault true;

    # Enable CPU microcode updates
    cpu.intel.updateMicrocode = lib.mkDefault true;
    cpu.amd.updateMicrocode = lib.mkDefault true;
  };

  # Performance optimizations for live images
  systemd.services = {
    # Disable some heavyweight services for faster boot
    "systemd-journal-flush".enable = lib.mkDefault false;

    # Optimize journal settings for live environment
    "systemd-journald".serviceConfig = {
      SystemMaxUse = lib.mkDefault "100M";
      RuntimeMaxUse = lib.mkDefault "50M";
    };
  };

  # Memory optimization
  boot.kernel.sysctl = {
    # Reduce swappiness for better live image performance
    "vm.swappiness" = lib.mkDefault 10;
    # Optimize memory management for live environment
    "vm.dirty_ratio" = lib.mkDefault 15;
    "vm.dirty_background_ratio" = lib.mkDefault 5;
  };

  # Zram configuration for better memory usage
  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = lib.mkDefault "zstd";
    memoryPercent = lib.mkDefault 25;
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
