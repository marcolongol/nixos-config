# Live CD User Profile
# User configuration for live images - disables impermanence
{ lib, ... }: {
  # Disable user-level impermanence by removing the persistence configuration
  home.persistence = lib.mkForce { };
}
