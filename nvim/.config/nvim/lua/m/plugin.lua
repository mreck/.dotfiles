--vim.cmd [[packadd packer.nvim]]

local ensure_packer = function()
    local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
    -- Packer can manage itself
    use "wbthomason/packer.nvim"

    use "mbbill/undotree"
    use "tpope/vim-fugitive"
    use "numToStr/Comment.nvim"

    use {
        "rose-pine/neovim",
        as = "rose-pine",
    }

    use {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.1",
        requires = { {"nvim-lua/plenary.nvim"} },
    }

    use {
        "theprimeagen/harpoon",
        requires = { {"nvim-lua/plenary.nvim"} },
    }

    use {
        "nvim-treesitter/nvim-treesitter",
        run = function()
            local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
            ts_update()
        end,
    }

    use {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        requires = {
            -- LSP Support
            {"neovim/nvim-lspconfig"},             -- Required
            {                                      -- Optional
                "williamboman/mason.nvim",
                run = function()
                    pcall(vim.cmd, "MasonUpdate")
                end,
            },
            {"williamboman/mason-lspconfig.nvim"}, -- Optional

            -- Autocompletion
            {"hrsh7th/nvim-cmp"},     -- Required
            {"hrsh7th/cmp-nvim-lsp"}, -- Required
            {"L3MON4D3/LuaSnip"},     -- Required
        }
    }

    -- Automatically set up your configuration after cloning packer.nvim
    if packer_bootstrap then
        require("packer").sync()
    end
end)

