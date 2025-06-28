{
  imports = [
    ./nvim-tree.nix
    ./telescope.nix
    ./lsp.nix
    ./schemastore.nix
    ./treesitter.nix
    ./bufferline.nix
    ./yanky.nix
    ./none-ls.nix
    ./trouble.nix
    ./toggleterm.nix
    ./luasnip.nix
    ./blink-cmp.nix
    ./lint.nix
  ];

  plugins = {
    # Copilot
    # copilot-vim.enable = true;
    # copilot-chat.enable = true;

    # Lazygit
    lazygit.enable = true;

    # Status line
    lualine.enable = true;

    # Git integration
    gitsigns.enable = true;

    # Auto pairs
    nvim-autopairs.enable = true;

    # Web development icons
    web-devicons.enable = true;

    # Mini Icons
    mini-icons.enable = true;

    # Which-key
    which-key.enable = true;

    # Nvim-lightbulb
    nvim-lightbulb.enable = true;

    # Gitblame
    gitblame.enable = true;

    # Nvim-notify
    notify = {
      enable = true;
      settings = {
        background_colour = "#000000";
        timeout = 3000; # 3 seconds
      };
    };

    # Indent-blankline
    indent-blankline = {
      enable = true;
      settings = { indent = { char = "┊"; }; };
    };

    # Nvim-surround
    nvim-surround.enable = true;
  };

  keymaps = [
    # Copilot
    {
      mode = "i";
      key = "<C-g>";
      action = "<cmd>CopilotChat<cr>";
      options.desc = "Open Copilot chat";
    }
    # Lazygit
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>LazyGit<cr>";
      options.desc = "Open Lazygit";
    }
  ];
}
