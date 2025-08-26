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

      # Gaming-specific services
      services = {
        # IRQ balancing for better multi-core CPU utilization and thermal distribution
        irqbalance.enable = true;

        # Low-latency audio for gaming
        pipewire = {
          extraConfig.pipewire."92-low-latency" = {
            context.properties = {
              default.clock.rate = 48000;
              default.clock.quantum = 32; # Lower latency
              default.clock.min-quantum = 32;
              default.clock.max-quantum = 32;
            };
          };
        };
      };

      # Real-time audio support for gaming
      security.rtkit.enable = true;

      # NVIDIA optimizations for gaming
      hardware.nvidia-custom = {
        # Switch to sync mode for gaming - uses NVIDIA GPU full time for better performance
        hybrid.mode = lib.mkForce "sync";
        
        # Disable fine-grained power management in sync mode (not compatible)
        powerManagement.finegrained = lib.mkForce false;
        
        # Enable CUDA for better game compatibility and GPU compute
        enableCUDA = lib.mkForce true;
      };

      # Gaming-optimized power management (auto-cpufreq handles CPU scaling)
      # Override auto-cpufreq for maximum gaming performance
      services.auto-cpufreq = {
        settings = {
          charger = {
            governor = lib.mkForce "performance";
            scaling_min_freq = lib.mkForce 2500000;
            scaling_max_freq = lib.mkForce 4500000;
            turbo = lib.mkForce "auto";
          };
          battery = {
            governor = lib.mkForce "performance"; # Keep performance even on battery for gaming
            scaling_min_freq = lib.mkForce 2000000;
            scaling_max_freq = lib.mkForce 4000000;
            turbo = lib.mkForce "auto";
          };
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

        # Memory management optimizations for gaming
        "vm.swappiness" = 1; # Minimize swap usage for better performance
        "vm.dirty_ratio" = 15; # Limit dirty pages for consistent performance
        "vm.dirty_background_ratio" = 5; # Start background writeback earlier
        "vm.vfs_cache_pressure" = 50; # Keep file system cache longer
        "vm.page-cluster" = 0; # Disable page clustering for SSD

        # CPU scheduler optimizations for gaming workloads
        "kernel.sched_min_granularity_ns" = 10000000; # 10ms - better for interactive tasks
        "kernel.sched_wakeup_granularity_ns" = 15000000; # 15ms - reduce context switching overhead

        # Disable watchdog for performance
        "kernel.nmi_watchdog" = 0;

        # Audio latency optimizations for gaming
        "dev.hda.intel.power_save" = 0; # Disable audio power saving

        # I/O optimizations for gaming (reduces CPU load and heat)
        "vm.dirty_expire_centisecs" = 500; # Write dirty pages more frequently
        "vm.dirty_writeback_centisecs" = 100; # Background writeback every 1s

        # Gaming network optimizations
        "net.core.rmem_default" = 262144;
        "net.core.rmem_max" = 16777216;
        "net.core.wmem_default" = 262144;
        "net.core.wmem_max" = 16777216;
      };
    };
  };
}
