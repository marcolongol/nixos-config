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
  system.stateVersion = "25.05"; # Did you read the comment?

  # Add host-specific configuration here
  imports = [ ./hardware-configuration.nix ];

  # Timezone configuration
  time.timeZone = "America/Los_Angeles";

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
