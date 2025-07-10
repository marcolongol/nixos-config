# Admin User Profile
# System administration focused configuration

{ pkgs, lib, inputs, userConfig, osConfig ? { }, ... }: {
  # Administrative packages (extends common packages)
  home.packages = with pkgs; [
    # System monitoring
    htop
    iotop
    nethogs
    iftop
    lsof

    # Network tools
    nmap
    tcpdump
    wireshark-cli
    dig
    whois

    # System utilities
    lshw
    usbutils
    pciutils
    inxi

    # Security tools
    gnupg
    pass

    # Terminal tools
    vim
    tree
    file
  ];

  # Extended shell configuration for admin
  programs.zsh.shellAliases = {
    # Admin-specific aliases (extends common aliases)
    services = "systemctl list-units --type=service";
    timers = "systemctl list-timers --all --no-pager";
    ports = "ss -tulpn";
    mounts = "findmnt -D";
    logs = "journalctl -f";
    sysinfo = "inxi -Fxz";
  };

  programs.zsh.initContent = ''
    # Admin-specific environment
    export EDITOR=vim
    export PAGER=less

    # Useful functions
    meminfo() { cat /proc/meminfo | grep -E "(MemTotal|MemFree|MemAvailable|Buffers|Cached)" }
    diskinfo() { df -h && echo && lsblk }
  '';

  # GPG configuration
  programs.gpg = { enable = true; };

  # Tmux for session management
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    extraConfig = ''
      # Status bar with system info
      set -g status-right '#(uptime | cut -d"," -f 3-)'

      # Mouse support
      set -g mouse on
    '';
  };
}
