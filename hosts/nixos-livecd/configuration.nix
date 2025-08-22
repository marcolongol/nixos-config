# Live CD/Image Configuration
# Minimal configuration for generating bootable images and cloud images
# Most configuration is handled by the livecd profile
{
  lib,
  hostname,
  ...
}: {
  system.stateVersion = "25.11";
  networking.hostName = hostname;

  # Documentation override - disable for smaller images
  documentation = {
    info.enable = lib.mkForce false;
    man.enable = lib.mkDefault true;
    nixos.enable = lib.mkForce false; # Override profile default
  };
}
