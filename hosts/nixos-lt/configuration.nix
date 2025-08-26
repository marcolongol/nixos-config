# nixos-lt Configuration
# Host-specific configuration for nixos-lt
{
  config,
  lib,
  pkgs,
  hostname,
  ...
}: {
  networking.hostName = hostname;

  system.stateVersion = "25.05"; # Did you read the comment?

  imports = [./hardware-configuration.nix];

  time.timeZone = "America/Los_Angeles";

  powerManagement = {
    enable = true;
    # Let TLP handle CPU frequency scaling instead of setting a default governor
    cpuFreqGovernor = "schedutil"; # Use schedutil for better performance on modern CPUs
    powertop.enable = true; # Enable powertop for power management
  };

  # Laptop-specific services
  services = {
    # Thermal management
    thermald.enable = true;

    # Better laptop power management
    power-profiles-daemon.enable = false; # Disable if using auto-cpufreq

    # System76 Scheduler for better CPU scheduling on System76 hardware
    system76-scheduler.enable = true;

    # upower for battery management
    upower.enable = true;

    # Auto CPU frequency scaling
    auto-cpufreq = {
      enable = true;
      settings = {
        charger = {
          governor = "performance";
          scaling_min_freq = 2000000;
          scaling_max_freq = 4000000;
          turbo = "auto";
        };
        battery = {
          governor = "powersave";
          scaling_min_freq = 1000000;
          scaling_max_freq = 3000000;
          turbo = "auto";
        };
      };
    };
  };

  # System-level impermanence configuration
  environment.persistence."/persist" = lib.myLib.utils.mkSystemPersistence {};

  # Enable gaming specialisation for this host
  gaming.specialisation.enable = true;
}
