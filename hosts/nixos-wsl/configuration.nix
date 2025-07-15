# nixos-wsl Configuration
# Host-specific configuration for nixos-wsl
{ config
, lib
, pkgs
, hostname
, ...
}: {
  networking.hostName = hostname;

  system.stateVersion = "25.05"; # Did you read the comment?

  wsl.enable = true;
  wsl.defaultUser = "lucas";

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };

  # Services
  services.smartd.enable = false;

  # Timezone configuration
  time.timeZone = "America/Los_Angeles";
}
