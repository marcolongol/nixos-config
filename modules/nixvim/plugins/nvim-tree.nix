{
  plugins.nvim-tree = {
    enable = true;
    openOnSetup = true; # Don't auto-open, we'll use keybindings
    disableNetrw = true;
    hijackNetrw = true;
    view = {
      width = 30;
      side = "left";
    };
    renderer = {
      highlightGit = true;
      icons = {
        show = {
          file = true;
          folder = true;
          folderArrow = true;
          git = true;
        };
      };
    };
    actions = {
      openFile = {
        quitOnOpen = false;
        resizeWindow = true;
      };
    };
    git = {
      enable = true;
      ignore = false;
    };
    filters = {
      dotfiles = false;
      custom = [ ".git" "node_modules" ];
    };
    updateFocusedFile = {
      enable = true;
      updateRoot = false;
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
