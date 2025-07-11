# Scripts module
# Manages custom scripts for Lucas
{ pkgs, ... }: {
  home.file = {
    ".local/bin/wallpaper-manager" = {
      source = ./wallpaper-manager.sh;
      executable = true;
    };
    ".local/bin/wallctl" = {
      source = ./wallctl.sh;
      executable = true;
    };
  };

  # Ensure the local bin directory is in PATH
  home.sessionPath = [ "$HOME/.local/bin" ];
}
