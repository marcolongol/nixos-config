# Configuration files module
# Manages all dotfiles and configuration files for Lucas
{
  home.file = {
    # Alacritty terminal configuration
    ".config/alacritty/alacritty.toml".source = ./alacritty.toml;
    ".config/hypr/hyprland.conf".source = ./hyprland.conf;

    # Add other configuration files here as needed
    # ".config/nvim/init.lua".source = ./.config/nvim/init.lua;
    # ".gitconfig".source = ./.config/gitconfig;
  };
}
