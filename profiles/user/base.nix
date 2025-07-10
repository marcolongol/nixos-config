{ pkgs, lib, inputs, userConfig, osConfig ? { }, ... }:

let
  # Check if osConfig is properly provided (indicating NixOS integration)
  # When using standalone home-manager, osConfig defaults to { } and lacks environment
  persistenceEnabled = if osConfig ? environment then
    osConfig.environment.persistence != { }
  else
    lib.warn ''
      WARNING: Using standalone home-manager without NixOS integration.
      Persistence features are disabled. If this system uses impermanence,
      please use 'sudo nixos-rebuild switch --flake .' instead of 'home-manager switch'.
    '' false;

in {

  imports = [ inputs.impermanence.homeManagerModules.impermanence ];

  # Base user profile for all users
  home.username = lib.mkDefault userConfig.name;
  home.homeDirectory = lib.mkDefault "/home/${userConfig.name}";

  # Home directory management
  home.stateVersion = "25.05";

  # Enable impermanence for home directory when persistence is enabled at system level
  home.persistence."/persist/home/${userConfig.name}" =
    lib.mkIf persistenceEnabled (lib.mkDefault {
      directories = [ "Downloads" "Documents" "Pictures" "Work" "Personal" ];
      files = [ ];
      allowOther = false;
    });

  # Copy wallpapers to user's Pictures directory
  home.file = {
    "Pictures/Wallpapers" = {
      source = "${lib.myLib.assetsDir}/wallpapers";
      recursive = true;
    };
  };

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
  programs.zsh = lib.mkDefault {
    enable = true;
    enableCompletion = true;

    # Common aliases for all users
    shellAliases = lib.mkDefault {
      work = "cd ~/work";
      personal = "cd ~/personal";
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

