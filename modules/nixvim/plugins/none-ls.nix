{
  plugins.none-ls = {
    enable = true;
    enableLspFormat = true;
    settings = {
      cmd = [ "nvim" ];
      debug = true;
      notify-format = "[null-ls] %s";
    };
    sources = {
      code_actions = {
        statix.enable = true;
        gitsigns.enable = true;
      };
      diagnostics = {
        statix.enable = true;
        deadnix.enable = true;
        pylint.enable = true;
        checkstyle.enable = true;
        mypy.enable = true;
      };
      formatting = {
        alejandra.enable = true;
        stylua.enable = true;
        shfmt.enable = true;
        nixpkgs_fmt.enable = true;
        google_java_format.enable = false;
        yamlfmt.enable = true;
        prettier = {
          enable = true;
          disableTsServerFormatter = true;
        };
        black = {
          enable = true;
          settings = ''
            {
              extra_args = { "--fast" },
            }
          '';
        };
      };
      hover = { dictionary.enable = true; };
      completion = {
        luasnip.enable = true;
        spell.enable = true;
      };
    };
  };
}
