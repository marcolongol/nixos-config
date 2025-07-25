# Development tools and environments
# Essential programming tools
{ lib
, pkgs
, config
, ...
}: {
  environment.systemPackages = with pkgs; [
    # Version control (git is also in common, but that's fine for clarity)
    git
    lazygit

    # Editors
    vscode
    neovim

    # Programming languages (install via project-specific shells)
    nodejs
    python3

    # Build essentials
    gcc
    gnumake

    # Containers
    docker
    docker-compose

    # Terminal tools
    alacritty
    tmux
    fd # Better find for telescope
    go-task
    k9s
    kubectl

    # System analysis
    btop

    # Language servers
    nixd

    # Code formatting
    alejandra

    talosctl
    talhelper
  ];

  # Development services
  virtualisation.docker.enable = lib.mkDefault true;

  # Environment management
  programs.direnv.enable = lib.mkDefault true;

  # Documentation
  documentation.dev.enable = lib.mkDefault true;
}
