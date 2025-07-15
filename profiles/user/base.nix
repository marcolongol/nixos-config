{ pkgs
, lib
, inputs
, userConfig
, osConfig ? { }
, ...
}: {
  imports = [ inputs.impermanence.homeManagerModules.impermanence ];

  # Base user profile for all users
  home.username = lib.mkDefault userConfig.name;
  home.homeDirectory = lib.mkDefault "/home/${userConfig.name}";

  # Home directory management
  home.stateVersion = "25.05";

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

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Dark";
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    font = {
      name = "Sans";
      size = 11;
    };
  };
}
