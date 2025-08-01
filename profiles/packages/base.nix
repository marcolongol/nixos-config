# Common packages shared across all systems
# Minimal essential tools for all systems
{ lib
, pkgs
, config
, ...
}: {
  # Nix settings for package management
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
    age
    sops
    p7zip
    zip
    unzip
    xz
    zstd

    # System information and utilities
    pfetch
    lshw
    coreutils
    psmisc

    # Basic text processing
    ripgrep
    jq
  ];

  services = {
    # Firmware updates for hardware components
    fwupd.enable = lib.mkDefault true;
    # SMART monitoring for hard drives
    smartd.enable = lib.mkDefault true;
  };

  hardware = {
    # Enable Bluetooth support
    bluetooth = {
      enable = lib.mkDefault true;
      powerOnBoot = lib.mkDefault true;
    };
  };

  # Sudo configuration
  security.sudo.wheelNeedsPassword = lib.mkDefault false;

  # Fuse
  programs.fuse.userAllowOther = lib.mkDefault true;

  # Dconf
  programs.dconf.enable = lib.mkDefault true;

  # Network Configuration
  networking.networkmanager.enable = lib.mkDefault true;

  # Mount NFS file systems
  fileSystems =
    let
      device = "10.0.0.4:/volume1";
      fsType = "nfs";
      options = [
        "rw"
        "hard"
        "nfsvers=4"
        "rsize=1048576"
        "wsize=1048576"
        "timeo=5"
        "retrans=3"
        "noatime"
        "async"
        "tcp"
      ];
      nfsMounts = [ "Backup" "Documents" "Downloads" "K8s" "Media" "Shared" ];
      nfsMountAttrs = builtins.listToAttrs (
        map
          (name: {
            name = "/mnt/${name}";
            value = {
              inherit options fsType;
              device = "${device}/${name}";
            };
          })
          nfsMounts
      );
    in
    nfsMountAttrs;
}
