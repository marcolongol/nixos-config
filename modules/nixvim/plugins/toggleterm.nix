{
  plugins.toggleterm = {
    enable = true;
    settings = {
      size = 60;
      hideNumbers = true;
      shadeFiletypes = [ "toggleterm" ];
      direction = "vertical";
      closeOnExit = true;
      shell = "zsh";
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "<C-t>";
      action = "<cmd>ToggleTerm<CR>";
      options.desc = "Toggle terminal";
    }
    {
      mode = "t";
      key = "<esc>";
      action = "<C-\\><C-n>";
    }
    {
      mode = "t";
      key = "<C-h>";
      action = "<C-\\><C-n><C-w>h";
      options.desc = "Move to left window in terminal mode";
    }
    {
      mode = "t";
      key = "<C-j>";
      action = "<C-\\><C-n><C-w>j";
      options.desc = "Move to below window in terminal mode";
    }
    {
      mode = "t";
      key = "<C-k>";
      action = "<C-\\><C-n><C-w>k";
      options.desc = "Move to above window in terminal mode";
    }
    {
      mode = "t";
      key = "<C-l>";
      action = "<C-\\><C-n><C-w>l";
      options.desc = "Move to right window in terminal mode";
    }
    {
      mode = "t";
      key = "<C-t>";
      action = "<C-\\><C-n>:ToggleTerm<CR>";
      options.desc = "Toggle terminal in terminal mode";
    }
    {
      mode = "t";
      key = "<A-1>";
      action = "<C-\\><C-n>:TermNew direction=vertical<CR>";
    }
  ];
}
