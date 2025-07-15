# nixos-lt Configuration
# Host-specific configuration for nixos-lt
{ config
, lib
, pkgs
, hostname
, ...
}: {
  networking.hostName = hostname;

  system.stateVersion = "25.05"; # Did you read the comment?

  imports = [ ./hardware-configuration.nix ];

  time.timeZone = "America/Los_Angeles";

  powerManagement = {
    enable = true;
    # Let TLP handle CPU frequency scaling instead of setting a default governor
    # cpuFreqGovernor = lib.mkDefault "powersave";
  };

  # Laptop-specific services
  services = {
    # Thermal management
    thermald.enable = true;

    # Better laptop power management
    power-profiles-daemon.enable = false; # Disable if using TLP

    # upower for battery management
    upower.enable = true;

    tlp = {
      enable = true;

      settings = {
        # CPU Scaling Governor
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        # CPU Energy Performance Policy
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        # CPU Performance Scaling
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

        # WiFi Power Management
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";

        # Runtime Power Management
        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "auto";

        # Battery Care (extends battery lifespan)
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };

  # System-level impermanence configuration
  environment.persistence."/persist" = lib.myLib.utils.mkSystemPersistence { };
}
