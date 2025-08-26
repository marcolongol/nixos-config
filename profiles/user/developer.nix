# Developer User Profile
# Comprehensive development environment with modern tooling
{
  pkgs,
  lib,
  inputs,
  userConfig,
  osConfig ? {},
  ...
}: {
  # Development packages (extends common packages)
  home.packages = with pkgs; [
    # Terminal enhancements
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
    starship
    eza
    bat
    fzf
    zoxide

    # Development tools
    lazygit
    delta

    # Language tools
    tree-sitter
    shellcheck

    # System utilities
    bottom
    dust
    procs
    lynx

    # Custom packages
    custom.nixvim

    # Programming Languages
    (python3.withPackages (ps:
      with ps; [
        black
        flake8
        isort
        mypy
        pylint
        pyright
        ruff
        pytest
        requests
        numpy
        pandas
        pandas-stubs
        psutil
        types-psutil
      ]))
  ];

  # Extended shell configuration for developers
  programs.zsh = {
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # Developer-specific aliases (extends common aliases)
      ls = "eza";
      ll = "eza -la"; # Override common ll
      cat = "bat";
      cd = "z";
      top = "btm";
      du = "dust";
      ps = "procs";
    };

    initContent = ''
      # History settings
      HISTSIZE=10000
      HISTFILE=~/.zsh_history
      SAVEHIST=10000
      HISTDUP=1000
      setopt append_history # Append to the history file
      setopt share_history # Share history across sessions
      setopt hist_ignore_space # Ignore commands starting with space
      setopt hist_save_no_dups # Save history without duplicates
      setopt hist_ignore_all_dups # Ignore duplicates in history
      setopt hist_find_no_dups # Find history without duplicates
      setopt hist_verify # Verify history expansion

      # bindkey settings
      bindkey -e # Use emacs keybindings
      bindkey '^p' up-line-or-search # Up arrow for history search
      bindkey '^n' down-line-or-search # Down arrow for history search

      # Initialize zoxide
      eval "$(zoxide init zsh)"

      # Initialize starship
      eval "$(starship init zsh)"

      # Initialize fzf
      eval "$(fzf --zsh)"

      # zstyle
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' list-colors \
        'di=01;34:ln=01;36:so=01;35:pi=40;33:ex=01;32:bd=40;33;01:cd=40;33;01:su=37;41:sg=30;43:tw=30;42:ow=34;42'
      zstyle ':completion:*' menu no
    '';
  };

  # Extended git configuration
  programs.git = {
    delta.enable = true;
    extraConfig = {
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  # Direnv for project environments
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      format = "$all$character";
      right_format = "$time";

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      time = {
        disabled = false;
        format = "[$time](dimmed white)";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
    };
  };

  # Tmux configuration
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    plugins = with pkgs.tmuxPlugins; [
      resurrect
      continuum
      sensible
      prefix-highlight
      tmux-powerline
    ];
    extraConfig = ''
      # Mouse support
      set -g mouse on

      # Status bar
      set -g status-bg colour234
      set -g status-fg colour137

      # Window navigation
      bind -n C-h select-pane -L
      bind -n C-j select-pane -D
      bind -n C-k select-pane -U
      bind -n C-l select-pane -R

      # Plugin Configuration
      set -g @resurrect-dir '~/.config/tmux/resurrect'
      set -g @resurrect-capture-pane-contents 'on'
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '15'
    '';
  };
}
