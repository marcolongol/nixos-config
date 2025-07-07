# nixos-lt Configuration
# Host-specific configuration for nixos-lt

{ config, lib, pkgs, hostname, ... }:

{
  networking.hostName = hostname;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  # Add host-specific configuration here
  imports = [ ./hardware-configuration.nix ];

  # Boot configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Timezone configuration
  time.timeZone = "America/Los_Angeles";

  # NVIDIA Graphics Configuration
  # GeForce RTX 4060 Max-Q with Intel UHD Graphics 770 hybrid setup
  hardware.nvidia-custom = {
    enable = true;

    # Hybrid graphics configuration (Intel + NVIDIA)
    hybrid = {
      enable = true;
      mode =
        "offload"; # Use Intel by default, NVIDIA on demand for better battery life
      busId = {
        intel = "PCI:0:2:0"; # Intel Alder Lake-HX GT1 [UHD Graphics 770]
        nvidia = "PCI:1:0:0"; # NVIDIA GeForce RTX 4060 Max-Q / Mobile
      };
    };

    # Power management for laptop (RTX 40 series supports fine-grained)
    powerManagement = {
      enable = true;
      finegrained = true; # RTX 4060 supports fine-grained power management
    };

    # Additional features
    enableCUDA = false; # Set to true if you need CUDA for ML/compute workloads
    enableVulkan = true; # Enable for gaming and modern graphics applications

    # Settings
    settings = {
      modesetting = true;
      useGBM = true; # Better Wayland support
      forceCompositionPipeline =
        false; # Enable if you experience screen tearing
    };
  };

  # Additional hardware optimizations for this specific laptop
  # Intel CPU optimizations
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Power management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "powersave"; # Good for laptop battery life
  };

  # Laptop-specific services
  services = {
    # Thermal management
    thermald.enable = true;

    # Better laptop power management
    power-profiles-daemon.enable = false; # Disable if using TLP
    tlp = {
      enable = true;
      settings = {
        # Battery optimization
        TLP_DEFAULT_MODE = "BAT";
        TLP_PERSISTENT_DEFAULT = 1;

        # CPU scaling
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        # NVIDIA power management
        RUNTIME_PM_ON_AC = "auto";
        RUNTIME_PM_ON_BAT = "auto";
      };
    };
  };

}
