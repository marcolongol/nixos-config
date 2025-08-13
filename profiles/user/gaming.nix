# Gaming user profile
# Provides gaming-specific home configuration and persistence
# Works with the gaming specialisation for optimal performance
{ pkgs
, lib
, inputs
, userConfig
, osConfig ? { }
, ...
}: {
  # Gaming-related home packages (user-specific utilities)
  home.packages = with pkgs; [
    # Additional gaming utilities for user space
    steam-run
    steamcmd
  ];

  # Gaming-specific environment variables
  home.sessionVariables = {
    # Steam runtime directories
    STEAM_RUNTIME_PATH = "$HOME/.steam/root/ubuntu12_32/steam-runtime";

    # Wine/gaming directories
    WINEPREFIX = "$HOME/.wine";
  };
}
