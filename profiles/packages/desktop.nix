# Desktop environment and applications profile
{ lib
, pkgs
, config
, ...
}: {
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
    nautilus
    catppuccin-sddm
    brightnessctl
    pywal

    # Terminal emulators
    kitty
    alacritty
  ];

  # Hyprland Window Manager
  programs.hyprland = {
    enable = lib.mkDefault true;
    xwayland.enable = lib.mkDefault true;
    withUWSM = true;
  };

  # Lock screen utility for Hyprland
  programs.hyprlock.enable = lib.mkDefault true;

  # XDG Desktop Portal
  xdg.portal = {
    enable = lib.mkDefault true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-wlr ];
  };

  # Environment Variables
  environment.sessionVariables = { WLR_NO_HARDWARE_CURSORS = "1"; };

  # Services
  services = {
    printing.enable = lib.mkDefault true;
    blueman.enable = lib.mkDefault true;
    hypridle.enable = lib.mkDefault true;

    # Display Manager Configuration
    displayManager = {
      defaultSession = "hyprland-uwsm";
      sddm = {
        enable = lib.mkDefault true;
        wayland.enable = lib.mkDefault true;
        theme = "catppuccin-mocha";
        package = pkgs.kdePackages.sddm;
      };
    };

    # Disable X11 to force Wayland
    xserver.enable = lib.mkDefault false;
  };

  # Audio System
  security.rtkit.enable = lib.mkDefault true;
  services.pipewire = {
    enable = lib.mkDefault true;
    alsa.enable = lib.mkDefault true;
    pulse.enable = lib.mkDefault true;
    jack.enable = lib.mkDefault true;
  };

  # Graphics Support
  hardware.graphics.enable = lib.mkDefault true;

  # Fonts
  fonts.packages = with pkgs; [
    # Basic fonts
    noto-fonts

    # Nerd fonts for programming
    nerd-fonts.meslo-lg
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [ "MesloLGS Nerd Font" ];
    sansSerif = [ "MesloLGS Nerd Font" ];
    serif = [ "MesloLGS Nerd Font" ];
  };
}
