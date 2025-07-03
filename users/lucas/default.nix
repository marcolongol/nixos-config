# Lucas's Individual User Configuration
# This file contains custom configurations specific to Lucas
# It extends the base developer profile with personal preferences
{ pkgs, lib, userConfig ? null, ... }: {
  # Import additional configuration modules
  imports = [ ./config ];

  # Disable nixpkgs version mismatch warnings
  home.enableNixpkgsReleaseCheck = false;

  home.packages = with pkgs; [
    # Personal productivity tools
    obsidian
    discord
    _1password-gui
    _1password-cli

    # Communication tools
    webex

    # Version control and development tools
    gh
    docker-compose
    k9s
    kubectl
  ];

  # Custom home directory structure
  home.file = {
    ".config/personal-scripts/.keep".text = "";
    "work/.keep".text = "";
    "personal/.keep".text = "";
  };

  programs.home-manager = { enable = true; };

  # Personal git configuration
  programs.git = {
    enable = true;
    userName = "Lucas Marcolongo";
    userEmail = "lucas_marco@live.com";
    extraConfig = {
      core.editor = "nvim";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      gpg.format = "ssh";
      "gpg \"ssh\"".program =
        "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      commit.gpgSign = false;
    };
  };

  # Personal SSH configuration
  programs.ssh = {
    enable = true;
    extraConfig = ''
      IdentityAgent ~/.1password/agent.sock
    '';
  };

  # Personal shell configuration
  programs.zsh.shellAliases = {
    # Personal shortcuts
    work = "cd ~/work";
    personal = "cd ~/personal";
    nixconfig = "cd /etc/nixos";

    # Docker shortcuts
    dps = "docker ps";
    dcup = "docker-compose up -d";
    dcdown = "docker-compose down";
  };

  # Lucas's specific environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };
}

