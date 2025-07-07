# Desktop environment and applications profile
{ config, lib, pkgs, ... }:

{
  # Desktop Applications
  environment.systemPackages = with pkgs; [
    # Essential applications
    firefox
    gimp
    vlc

    # Wayland desktop environment
    waybar
    dunst
    libnotify
    swww
    rofi-wayland

    # Terminal emulators
    kitty
    alacritty
  ];

  # Hyprland Window Manager
  programs.hyprland = {
    enable = lib.mkDefault true;
    xwayland.enable = lib.mkDefault true;
  };

  # XDG Desktop Portal
  xdg.portal = {
    enable = lib.mkDefault true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-wlr ];
  };

  # Environment Variables
  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
  };

  # Services
  services = {
    printing.enable = lib.mkDefault true;
    blueman.enable = lib.mkDefault true;
    picom.enable = lib.mkDefault true; # Compositor for transparency and effects
  };

  # Audio System
  sound.enable = lib.mkDefault true;
  security.rtkit.enable = lib.mkDefault true;
  services.pipewire = {
    enable = lib.mkDefault true;
    alsa.enable = lib.mkDefault true;
    pulse.enable = lib.mkDefault true;
    jack.enable = lib.mkDefault true;
  };

  # Graphics Support
  hardware = {
    bluetooth = {
      enable = lib.mkDefault true;
      powerOnBoot = lib.mkDefault true;
    };
    opengl = {
      enable = lib.mkDefault true;
      driSupport = lib.mkDefault true;
      driSupport32Bit = lib.mkDefault true;
    };
  };

  # Fonts
  fonts.packages = with pkgs; [
    # Basic fonts
    noto-fonts

    # Nerd fonts for programming
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];

  # Network Configuration
  networking.networkmanager.enable = lib.mkDefault true;
}
