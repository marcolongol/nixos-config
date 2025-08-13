# Gaming Specialisation Module
# Provides a gaming-optimized boot option with Steam, performance tweaks, and relaxed security
{ config, lib, pkgs, ... }:

{
  options.gaming.specialisation.enable = lib.mkEnableOption "gaming specialisation";

  config = lib.mkIf config.gaming.specialisation.enable {
    specialisation.gaming.configuration = {
    # Gaming Applications and Tools
    environment.systemPackages = with pkgs; [
      # Gaming clients and tools
      lutris
      heroic
      bottles
      gamescope
      mangohud
      
      # Gaming utilities
      protontricks
      winetricks
      
      # Performance monitoring
      gpu-viewer
    ];

    # Steam with Proton support
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
      
      # Extra compatibility tools for Steam
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    # GameMode for performance optimization
    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
          ioprio = 7;
          inhibit_screensaver = 1;
          desiredgov = "performance";
          defaultgov = "powersave";
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          amd_performance_level = "high";
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };

    # Steam hardware support
    hardware.steam-hardware.enable = true;

    # Gaming-optimized power management (override TLP for gaming)
    powerManagement.cpuFreqGovernor = lib.mkForce "performance";
    
    services.tlp = {
      settings = {
        # Override TLP settings for gaming performance
        CPU_SCALING_GOVERNOR_ON_AC = lib.mkForce "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = lib.mkForce "performance";
        CPU_ENERGY_PERF_POLICY_ON_AC = lib.mkForce "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = lib.mkForce "balance_performance";
        CPU_MIN_PERF_ON_AC = lib.mkForce 50;
        CPU_MAX_PERF_ON_AC = lib.mkForce 100;
        CPU_MIN_PERF_ON_BAT = lib.mkForce 30;
        CPU_MAX_PERF_ON_BAT = lib.mkForce 80;
        
        # Disable power saving features that can impact gaming
        WIFI_PWR_ON_AC = lib.mkForce "off";
        WIFI_PWR_ON_BAT = lib.mkForce "off";
        RUNTIME_PM_ON_AC = lib.mkForce "on";
        RUNTIME_PM_ON_BAT = lib.mkForce "on";
      };
    };

    # Gaming-optimized kernel parameters
    boot.kernel.sysctl = {
      # Increase memory map areas for games (required by some modern games like CS2, Apex Legends)
      "vm.max_map_count" = 2147483642;
      
      # Gaming network optimizations
      "net.core.rmem_default" = 262144;
      "net.core.rmem_max" = 16777216;
      "net.core.wmem_default" = 262144;
      "net.core.wmem_max" = 16777216;
    };

    # Relaxed firewall for gaming (allow Steam and game traffic)
    networking.firewall = {
      allowedTCPPorts = [
        22        # SSH (from security profile)
        27036     # Steam Remote Play
        27037     # Steam Remote Play
        27015     # Steam game traffic
      ];
      allowedUDPPorts = [
        27031     # Steam Remote Play
        27036     # Steam Remote Play  
        27015     # Steam game traffic
      ];
      # Allow Steam to open additional ports as needed (minimal range for security)
      allowedTCPPortRanges = [
        { from = 27014; to = 27050; }  # Steam client and game traffic
      ];
      allowedUDPPortRanges = [
        { from = 27000; to = 27031; }  # Steam client traffic (reduced range)
        { from = 27036; to = 27037; }  # Steam Remote Play specific
      ];
    };

    # Gaming-related environment variables
    environment.sessionVariables = {
      # Enable mangohud by default for supported games
      MANGOHUD = "1";
      
      # Steam proton variables for better compatibility
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/$USER/.steam/root/compatibilitytools.d";
      
      # NVIDIA specific gaming optimizations
      __GL_SHADER_DISK_CACHE = "1";
      __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
      
      # Wine/gaming directories for user profile compatibility
      WINEPREFIX = "$HOME/.wine";
    };

    # Gaming notification at boot
    environment.etc."gaming-mode".text = ''
      Gaming Mode Active
      - GameMode enabled for performance optimization
      - Steam and gaming services running
      - Relaxed firewall for multiplayer gaming
      - Performance-oriented power management
    '';
    };
  };
}