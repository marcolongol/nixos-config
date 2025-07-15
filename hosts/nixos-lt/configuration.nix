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
    cpuFreqGovernor = lib.mkDefault "powersave"; # Good for laptop battery life
  };

  # Laptop-specific services
  services = {
    # Thermal management
    thermald.enable = true;

    # Better laptop power management
    power-profiles-daemon.enable = true; # Disable if using TLP

    # upower for battery management
    upower.enable = true;
  };

  # System-level impermanence configuration
  environment.persistence."/persist" = lib.myLib.utils.mkSystemPersistence { };
}
