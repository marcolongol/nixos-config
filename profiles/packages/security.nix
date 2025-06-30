# Security hardening and monitoring tools
# Additional security measures for exposed systems

{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Security monitoring tools
    fail2ban

    # Network security
    nmap
    netcat-gnu

    # System monitoring
    lynis
  ];

  # fail2ban configuration
  services.fail2ban = {
    enable = lib.mkDefault true;

    # Global settings
    maxretry = lib.mkDefault 3;
    bantime = lib.mkDefault "1h";

    # Jail configurations using new format
    jails = {
      # Default settings
      DEFAULT.settings = {
        loglevel = "INFO";
        logtarget = "/var/log/fail2ban.log";
        findtime = "10m";
      };

      # General auth failures
      pam-generic.settings = {
        enabled = true;
        banaction = "iptables-multiport";
        logpath = "/var/log/auth.log";
        maxretry = 5;
        findtime = 600;
      };
    };
  };

  # Enhanced logging for security monitoring
  services.journald.extraConfig = ''
    Storage=persistent
    Compress=yes
    SystemMaxUse=1G
    RuntimeMaxUse=100M
  '';

  # Basic firewall (can be customized per host)
  networking.firewall = {
    enable = lib.mkDefault true;
    allowPing = lib.mkDefault false;

    # Only allow SSH by default
    allowedTCPPorts =
      lib.mkDefault (lib.optional config.services.openssh.enable 22);
  };

  # Security kernel parameters
  boot.kernel.sysctl = {
    # Network security
    "net.ipv4.ip_forward" = lib.mkDefault 0;
    "net.ipv4.conf.all.send_redirects" = lib.mkDefault 0;
    "net.ipv4.conf.default.send_redirects" = lib.mkDefault 0;
    "net.ipv4.conf.all.accept_redirects" = lib.mkDefault 0;
    "net.ipv4.conf.default.accept_redirects" = lib.mkDefault 0;
    "net.ipv4.conf.all.accept_source_route" = lib.mkDefault 0;
    "net.ipv4.conf.default.accept_source_route" = lib.mkDefault 0;

    # TCP hardening
    "net.ipv4.tcp_syncookies" = lib.mkDefault 1;
    "net.ipv4.tcp_rfc1337" = lib.mkDefault 1;
    "net.ipv4.tcp_fin_timeout" = lib.mkDefault 15;
    "net.ipv4.tcp_keepalive_time" = lib.mkDefault 300;

    # Memory protection (use mkOverride for conflicting options)
    "kernel.dmesg_restrict" = lib.mkDefault 1;
    "kernel.kptr_restrict" = lib.mkOverride 500 2;
    "kernel.yama.ptrace_scope" = lib.mkDefault 1;
  };

  # Automatic security updates for critical packages
  system.autoUpgrade = {
    enable = lib.mkDefault false; # Disabled by default, enable per host
    dates = "weekly";
    allowReboot = lib.mkDefault false;
  };
}
