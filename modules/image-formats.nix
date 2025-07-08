# nixos-generators format configurations
# Defines custom format configurations for different image types
{ lib, ... }: {

  imports = [ ];

  # Format-specific configurations
  formatConfigs = {
    # ISO format configuration
    iso = { ... }: {
      # ISO-specific settings
      isoImage = {
        makeEfiBootable = lib.mkDefault true;
        makeUsbBootable = lib.mkDefault true;
        # Increase ISO size limit if needed
        volumeID = lib.mkDefault "NIXOS_ISO";
      };
    };

    # Install ISO format (installation media)
    install-iso = { ... }: {
      isoImage = {
        makeEfiBootable = lib.mkDefault true;
        makeUsbBootable = lib.mkDefault true;
        volumeID = lib.mkDefault "NIXOS_INSTALL";
      };
    };

    # Amazon EC2 format
    amazon = { ... }: {
      ec2.hvm = lib.mkDefault true;
      # Optimize for cloud environment
      services.cloud-init.enable = lib.mkForce true;
      virtualisation.diskSize = lib.mkDefault (8 * 1024); # 8GB default
    };

    # Microsoft Azure format
    azure = { ... }: {
      virtualisation.diskSize = lib.mkDefault (10 * 1024); # 10GB default
      # Azure-specific optimizations
      services.cloud-init.enable = lib.mkForce true;
    };

    # QCOW2 format (QEMU/KVM)
    qcow = { ... }: {
      virtualisation.diskSize = lib.mkDefault (20 * 1024); # 20GB default
      # QEMU optimizations
      services.qemuGuest.enable = lib.mkDefault true;
    };

    # QCOW2 with EFI support
    qcow-efi = { ... }: {
      virtualisation.diskSize = lib.mkDefault (20 * 1024); # 20GB default
      services.qemuGuest.enable = lib.mkDefault true;
      boot.loader.systemd-boot.enable = lib.mkDefault true;
      boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
    };

    # Raw disk image
    raw = { ... }: {
      virtualisation.diskSize = lib.mkDefault (20 * 1024); # 20GB default
      boot.loader.grub.device = lib.mkDefault "/dev/vda";
    };

    # Raw disk image with EFI
    raw-efi = { ... }: {
      virtualisation.diskSize = lib.mkDefault (20 * 1024); # 20GB default
      boot.loader.systemd-boot.enable = lib.mkDefault true;
      boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
    };

    # VirtualBox format
    virtualbox = { ... }: {
      virtualisation.diskSize = lib.mkDefault (20 * 1024); # 20GB default
      virtualisation.virtualbox.guest.enable = lib.mkDefault true;
    };

    # VMware format
    vmware = { ... }: {
      virtualisation.diskSize = lib.mkDefault (20 * 1024); # 20GB default
      virtualisation.vmware.guest.enable = lib.mkDefault true;
    };

    # Docker format
    docker = { ... }: {
      # Docker-specific optimizations
      boot.isContainer = lib.mkDefault true;
      services.openssh.enable = lib.mkDefault false;
    };

    # Digital Ocean format
    do = { ... }: {
      virtualisation.diskSize = lib.mkDefault (5 * 1024); # 5GB default for DO
      services.cloud-init.enable = lib.mkForce true;
    };

    # Google Compute Engine format
    gce = { ... }: {
      virtualisation.diskSize = lib.mkDefault (10 * 1024); # 10GB default
      services.cloud-init.enable = lib.mkForce true;
    };

    # Proxmox format
    proxmox = { ... }: {
      virtualisation.diskSize = lib.mkDefault (20 * 1024); # 20GB default
      services.qemuGuest.enable = lib.mkDefault true;
    };
  };
}
