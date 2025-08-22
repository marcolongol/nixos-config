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
        sqlfluff.enable = true;
        stylelint.enable = true;
        isort = {
          enable = true;
        };
        black = {
          enable = true;
          settings = {
            extra_args = [ "--fast" ];
            extra_filetypes = [ "tiltfile" ];
          };
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
