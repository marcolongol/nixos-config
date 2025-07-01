# Common packages shared across all systems
# Minimal essential tools for all systems

{ config, lib, pkgs, ... }:

{
  nix.settings.experimental-features = lib.mkDefault [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    # Essential CLI tools
    wget
    curl
    git
    vim
    htop
    tree
    unzip
    file
    openssh

    # System information and utilities
    pfetch
    lshw
    coreutils

    # Basic text processing
    ripgrep
    jq
  ];

  # SSH service with secure defaults
  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      # Security hardening
      PasswordAuthentication = lib.mkDefault false;
      PermitRootLogin = lib.mkDefault "no";
      PubkeyAuthentication = lib.mkDefault true;
      AuthenticationMethods = lib.mkDefault "publickey";

      # Connection settings
      ClientAliveInterval = lib.mkDefault 300;
      ClientAliveCountMax = lib.mkDefault 2;
      MaxAuthTries = lib.mkDefault 3;

      # Protocol settings
      Protocol = lib.mkDefault 2;
      X11Forwarding = lib.mkDefault false;
      AllowAgentForwarding = lib.mkDefault false;
      AllowTcpForwarding = lib.mkDefault "local";
    };

    # Only allow wheel group (sudoers) to SSH
    extraConfig = ''
      AllowGroups wheel
    '';
  };

  # Basic security
  security.sudo.wheelNeedsPassword = false;
}
