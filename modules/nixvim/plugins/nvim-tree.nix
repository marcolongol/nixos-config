{
  plugins.nvim-tree = {
    enable = true;
    openOnSetup = true; # Don't auto-open, we'll use keybindings
    settings = {
      disable_netrw = true;
      hijack_netrw = true;
      view = {
        width = 30;
        side = "left";
      };
      renderer = {
        highlight_git = true;
        icons = {
          show = {
            file = true;
            folder = true;
            folder_arrow = true;
            git = true;
          };
        };
      };
      actions = {
        open_file = {
          quit_on_open = false;
          resize_window = true;
        };
      };
      git = {
        enable = true;
        ignore = false;
      };
      filters = {
        dotfiles = false;
        custom = [".git" "node_modules"];
      };
      update_focused_file = {
        enable = true;
        update_root = false;
      };
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>NvimTreeToggle<cr>";
      options.desc = "Toggle file tree";
    }
    {
      mode = "n";
      key = "<leader>o";
      action = "<cmd>NvimTreeFocus<cr>";
      options.desc = "Focus file tree";
    }
    {
      mode = "n";
      key = "<leader>E";
      action = "<cmd>NvimTreeFindFile<cr>";
      options.desc = "Find current file in tree";
    }
  ];
}
