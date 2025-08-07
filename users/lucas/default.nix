# Lucas's Individual User Configuration
# This file contains custom configurations specific to Lucas
# It extends the base developer profile with personal preferences
{ pkgs
, lib
, userConfig
, osConfig ? { }
, ...
}: {
  # Enable impermanence for home directory when persistence is enabled at system level
  home.persistence."/persist/home/${userConfig.name}" = lib.myLib.utils.mkHomePersistence {
    inherit osConfig;
    allowOther = true;
    directories = [
      ".config/1Password"
      ".config/remmina"
      ".config/github-copilot"
      ".config/Code"
      ".claude"
      ".mozilla"
      ".thunderbird"
      "./.cache/wal"
      ".local/share/nvim"
      ".local/state/nvim"
    ];
    files = [ ".zsh_history" ".local/share/zoxide/db.zo" ".kube/config" ".claude.json" ];
  };

  home.file = {
    ".local/bin/" = {
      source = ./scripts;
      recursive = true;
      executable = true;
    };
    ".config" = {
      source = ./config;
      recursive = true;
    };
  };

  home.packages = with pkgs; [
    # Personal productivity tools
    obsidian
    discord
    _1password-gui
    _1password-cli

    # Communication tools
    webex

    # Remote access and management
    remmina

    # Misc
    yubikey-agent
    yubikey-manager
    yubikey-personalization
    yubikey-touch-detector
    freecad
    qgis
    gdal
  ];

  # Personal git configuration
  programs.git = {
    enable = true;
    userName = "Lucas Marcolongo";
    userEmail = "lucas_marco@live.com";
    extraConfig = {
      user.signingKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDNFeQPhPMI2W5Ot5B+Cs7XK5F2TmvjsAiLVD0Ix+tM8AUKjmjLc/Fvt3UvPqY+U09yfu1S6QTL41Q0xQln8MUU+r5DLWh01UiA4obC/m76MGP1Vv3tGubP6+18bJXxNXB7vhPsy5ruTjgAsbXep3PVKjjqZfdrKAiLBF0Zj380KOapZVTDf51vS5ClEFSTX6xgX6VB3rtjYs8aB2GxpAIniLTOmfhkednYhs3bdNRv/MLO0J6SL4+Z//gEg4bq9VsYZviOulBLt2176kk4fyPc2azdIII2Apk2Ulqr9RGvIJ5LVbNpsKDoLzEYPFW/sJ82z4o9uSYXMruKSQWrqkCo5GxsGAi7xTGcVFO0wKPxr3wWZW+K35V7jyWAJFamsnXQUoeXlfIu/DzUfgJ+TSILWWr6ZrV/y0ohkSp9hs1ByDsjmmLEI5SZDjDDs07zaEa6VO9eDuh3xsqB8s2vsaJ+fegDKxm08//rltAXhSx45EADCOzsCYNXteP8eexuqgBQAL11OSCKp6PX4SGDGnu9dip0jpDzZqVpY/AcIxFJsY7niKw+FIsT8lM+4Gxm4w3nUWGnKLTnxqZ4XMeU1a8dna9fIN1WG3i+fBqsNHD8kRuKTS/0BibXAnnlK9FBak1onbg5fuqlSvsV41EscfEbP6g4IkXqVevTK8Ud5ihNSQ==";
      core.editor = "nvim";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      gpg.format = "ssh";
      "gpg \"ssh\"".program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      commit.gpgSign = true;
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

  home.sessionPath = [ "$HOME/.local/bin" ];
}
