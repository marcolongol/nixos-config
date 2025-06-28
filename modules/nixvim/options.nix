{
  globals.mapleader = " ";

  # Editor options
  opts = {
    # Line numbers
    number = true;
    relativenumber = true;

    # Cursor line highlighting
    cursorline = true;
    cursorcolumn = false;

    # Indentation
    tabstop = 4;
    shiftwidth = 4;
    expandtab = true;
    autoindent = true;
    smartindent = true;

    # Search
    ignorecase = true;
    smartcase = true;
    hlsearch = true;
    incsearch = true;

    # UI improvements
    termguicolors = true;
    signcolumn = "yes";
    wrap = true;
    scrolloff = 8;
    sidescrolloff = 8;

    # Split behavior
    splitbelow = true;
    splitright = true;

    # Other useful options
    mouse = "a";
    clipboard = "unnamedplus";
    undofile = true;
    swapfile = false;
    backup = false;
    updatetime = 250;
    timeoutlen = 300;
    textwidth = 87;
    colorcolumn = "87";
    list = true;
    listchars = {
      tab = "» ";
      trail = "·";
      extends = "»";
      precedes = "«";
      nbsp = "␣";
      eol = "↲";
    };
    autoread = true;
  };

  colorschemes.oxocarbon.enable = true;

  extraConfigLua = ''
    -- Set the colorscheme
    vim.cmd [[
      hi Normal guibg=none
      hi Normal guibg=none
      hi NormalNC guibg=none
      hi NormalFloat guibg=none
      hi FloatBorder guibg=none
      hi Pmenu guibg=none
      hi PmenuSel guibg=none
      hi NvimTreeNormal guibg=none
      hi Comment guifg=#5c6370 gui=italic
    ]]

    -- Show eol character based on file format
    vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {
        callback = function()
            local listchars = vim.opt.listchars:get()
            listchars.eol = (vim.opt.fileformat:get() == "dos") and "↲" or "↓"
            vim.opt.listchars = listchars
        end,
    })
  '';
}
