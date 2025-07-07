{ pkgs, lib, userConfig, ... }:

{

  # Base user profile for all users
  home.username = lib.mkDefault userConfig.name;
  home.homeDirectory = lib.mkDefault "/home/${userConfig.name}";

  # Home directory management
  home.stateVersion = "25.05";

  # Essential packages for all users
  home.packages = with pkgs; [
    # Basic CLI tools
    curl
    wget
    tree
    file
    unzip
  ];

  programs.home-manager.enable = lib.mkDefault true;

  # Basic shell configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # Common aliases for all users
    shellAliases = lib.mkDefault {
      ll = "ls -l";
      la = "ls -la";
      grep = "grep --color=auto";
      ".." = "cd ..";
      "..." = "cd ../..";
    };
  };

  # Basic git configuration
  programs.git = {
    enable = lib.mkDefault true;
    extraConfig = lib.mkDefault { init.defaultBranch = "main"; };
  };

  # XDG directories
  xdg.enable = lib.mkDefault true;

  # Basic environment variables
  home.sessionVariables = lib.mkDefault { PAGER = "less"; };
}

