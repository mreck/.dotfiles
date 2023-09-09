vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"

vim.o.mouse = "a"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.hlsearch = false
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.completeopt = "menuone,noselect"
vim.o.termguicolors = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.clipboard = "unnamedplus"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },

  {
    "tpope/vim-fugitive",
  },

  {
    "tpope/vim-sleuth",
  },

  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable "make" == 1
        end,
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = "|",
        section_separators = "",
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },
})

require("telescope").setup {
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
        ["<C-j>"] = require("telescope.actions").move_selection_next,
        ["<C-k>"] = require("telescope.actions").move_selection_previous,
      },
    },
  },
}

pcall(require("telescope").load_extension, "fzf")

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set("i", "jk", "<ESC>", { silent = true })
vim.keymap.set("i", "kj", "<ESC>", { silent = true })

function nmap(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
end

nmap("H", "^",          "")
nmap("L", "$",          "")
nmap(";", ":",          "")
nmap("<C-s>", ":w<CR>", "")

nmap("<C-d>", "<C-d>zz", "")
nmap("<C-u>", "<C-u>zz", "")
nmap("{", "{zz",         "")
nmap("}", "}zz",         "")

nmap("<LEADER>wh", "<C-w>h",  "[W]indow Left")
nmap("<LEADER>wj", "<C-w>j",  "[W]indow Down")
nmap("<LEADER>wk", "<C-w>k",  "[W]indow Up")
nmap("<LEADER>wl", "<C-w>l",  "[W]indow Right")
nmap("<LEADER>ww", "<C-w>w",  "[W]indow Switch")
nmap("<LEADER>ws", "<C-w>s",  "[W]indow [S]plit")
nmap("<LEADER>wq", "<C-w>q",  "[W]indow [Q]uit")

nmap("<LEADER>bj", ":bn<CR>", "[B]uffer Next")
nmap("<LEADER>bk", ":bp<CR>", "[B]uffer Prev")

nmap("<C-p>",      require("telescope.builtin").git_files,                 "")
nmap("<LEADER>ff", require("telescope.builtin").find_files,                "[F]ind [F]iles")
nmap("<LEADER>fg", require("telescope.builtin").live_grep,                 "[F]ind [G]rep (live)")
nmap("<LEADER>fo", require("telescope.builtin").oldfiles,                  "[F]ind [O]ld Files")
nmap("<LEADER>fb", require("telescope.builtin").buffers,                   "[F]ind [B]uffers")
nmap("<LEADER>fq", require("telescope.builtin").quickfix,                  "[F]ind [Q]uickfixes")
nmap("<LEADER>fl", require("telescope.builtin").loclist,                   "[F]ind [L]oclist")
nmap("<LEADER>fm", require("telescope.builtin").man_pages,                 "[F]ind [M]an Pages")
nmap("<LEADER>fk", require("telescope.builtin").keymaps,                   "[F]ind [K]eymaps")
nmap("<LEADER>/",  require("telescope.builtin").current_buffer_fuzzy_find, "")

nmap("<LEADER>gs",  ":G<CR>",                                  "[G]it [S]tatus")
nmap("<LEADER>gfc", require("telescope.builtin").git_commits,  "[G]it [F]ind [C]ommit")
nmap("<LEADER>gfb", require("telescope.builtin").git_branches, "[G]it [F]ind [B]ranch")

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

-- vim: ts=2 sts=2 sw=2 et
