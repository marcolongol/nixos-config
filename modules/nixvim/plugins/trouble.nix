{
  plugins.trouble = {
    enable = true;
    settings = {
      diagnostics = {
        auto_open = true;
        auto_close = true;
        focus = true;
        indent_guides = true;
        use_diagnostics_signs = true;
      };
    };
  };
  keymaps = [{
    mode = "n";
    key = "<leader>xx";
    action = "<cmd>Trouble diagnostics toggle<cr>";
  }];
}
