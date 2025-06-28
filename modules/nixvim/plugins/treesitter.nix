{
  plugins.treesitter = {
    enable = true;
    # nixvimInjections = true;
    settings = {
      highlight = {
        enable = true;
        additional_vim_regex_highlighting = true;
      };
      indent = { enable = true; };
      folding = true;
      nixGrammars = true;
      auto_install = true;
      ensureInstalled = "all";
    };
  };

  plugins.treesitter-context = { enable = true; };

  plugins.treesitter-textobjects = {
    enable = true;
    select = {
      enable = true;
      lookahead = true;
    };
  };

  extraConfigLua = ''
    local parser_config = require'nvim-treesitter.parsers'.get_parser_configs()
  '';
}
