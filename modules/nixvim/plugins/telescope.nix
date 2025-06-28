{
  plugins.telescope = {
    enable = true;
    extensions = { fzf-native.enable = true; };
    settings = {
      defaults = {
        prompt_prefix = " ";
        selection_caret = " ";
        path_display = [ "truncate" ];
        sorting_strategy = "ascending";
        layout_strategy = "horizontal";
        layout_config = {
          horizontal = {
            prompt_position = "top";
            preview_width = 0.55;
            results_width = 0.8;
          };
          vertical = { mirror = false; };
          width = 0.87;
          height = 0.8;
          preview_cutoff = 120;
        };
        file_ignore_patterns =
          [ "^.git/" "^.svn/" "^node_modules/" "^%.cache/" ];
        winblend = 0;
        border = { };
        borderchars = [ "─" "│" "─" "│" "╭" "╮" "╯" "╰" ];
        color_devicons = true;
        use_less = true;
        set_env = { COLORTERM = "truecolor"; };
      };
      pickers = {
        find_files = {
          find_command = [ "fd" "--type" "f" "--strip-cwd-prefix" ];
        };
        buffers = {
          show_all_buffers = true;
          sort_lastused = true;
          previewer = false;
          mappings = {
            i = { "<c-d>" = "delete_buffer"; };
            n = { "dd" = "delete_buffer"; };
          };
        };
      };
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<cr>";
      options.desc = "Find files";
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<cr>";
      options.desc = "Live grep";
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>Telescope buffers<cr>";
      options.desc = "Find buffers";
    }
    {
      mode = "n";
      key = "<leader>fh";
      action = "<cmd>Telescope help_tags<cr>";
      options.desc = "Find help";
    }
    {
      mode = "n";
      key = "<leader>fr";
      action = "<cmd>Telescope oldfiles<cr>";
      options.desc = "Recent files";
    }
  ];
}
