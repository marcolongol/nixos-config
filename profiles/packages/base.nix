# Common packages shared across all systems
# Minimal essential tools for all systems

{ lib, pkgs, ... }:

{
  nix.settings.experimental-features = lib.mkDefault [ "nix-command" "flakes" ];

  # Automatic garbage collection to prevent disk space issues
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  # Optimize nix store periodically
  nix.optimise = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault [ "03:45" ];
  };

  # Persistent storage configuration
  # Creates the base persistent directories that Home Manager impermanence will use
  # This supports both regular filesystem and separate partition setups
  systemd.tmpfiles.rules = [
    "d /persist 0755 root root -"
    "d /persist/home 0755 root root -"
    # Note: User-specific directories need to be created with proper ownership
    # These will be created by the user profiles or individual user configs
  ];

  # System-level impermanence configuration
  # Only persists essential system files and directories
  # User-specific files are handled by home-manager impermanence
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
    ];
    files = [ "/etc/machine-id" ];
  };

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
    extraConfig = lib.mkDefault ''
      AllowGroups wheel
    '';
  };

  # Basic security
  security.sudo.wheelNeedsPassword = false;
}
