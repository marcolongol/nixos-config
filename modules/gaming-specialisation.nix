# Gaming Specialisation Module
# Provides a gaming-optimized boot option with Steam, performance tweaks, and relaxed security
{
  config,
  lib,
  pkgs,
  ...
}: {
  options.gaming.specialisation.enable = lib.mkEnableOption "gaming specialisation";

  config = lib.mkIf config.gaming.specialisation.enable {
    specialisation.gaming.configuration = {
      # Gaming Applications and Tools
      environment.systemPackages = with pkgs; [
        # Gaming clients and tools
        dxvk
        lutris
        mangohud
        steam-run

        # Gaming utilities
        protonup
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
        protontricks.enable = true;

        extraPackages = with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
          gamescope
          gamemode
        ];

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

      systemd.user.extraConfig = ''
        LimitMEMLOCK=infinity
        LimitNPROC=4096
        LimitCORE=0
      '';
      # Gaming-optimized kernel parameters
      boot.kernel.sysctl = {
        # Increase file descriptor limits for gaming applications
        "fs.file-max" = 2097152;

        # Increase memory map areas for games (required by some modern games like CS2, Apex Legends)
        "vm.max_map_count" = 2147483642;

        # Gaming network optimizations
        "net.core.rmem_default" = 262144;
        "net.core.rmem_max" = 16777216;
        "net.core.wmem_default" = 262144;
        "net.core.wmem_max" = 16777216;
      };
    };
  };
}
