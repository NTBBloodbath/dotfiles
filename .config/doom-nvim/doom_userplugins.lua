-- doom_userplugins - Doom nvim custom plugins
--
-- This file contains all the custom plugins that are not in Doom nvim but that
-- the user requires. All the available fields can be found here
-- https://github.com/wbthomason/packer.nvim#specifying-plugins
--
-- By example, for including a plugin with a dependency on telescope:
-- M.plugins {
--   {
--     'user/repository',
--     requires = { 'nvim-lua/telescope.nvim' },
--   },
-- }

local M = {}

M.source = debug.getinfo(1, "S").source:sub(2)

M.plugins = {
  -- Colorschemes
  {
    "eddyekofo94/gruvbox-flat.nvim",
    config = function()
      vim.g.gruvbox_flat_style = "dark"
      vim.g.gruvbox_italic_comments = false
      vim.g.gruvbox_italic_keywords = false
      vim.g.gruvbox_italic_functions = false
      vim.g.gruvbox_italic_variables = false
      vim.g.gruvbox_dark_sidebar = {
        "packer",
        "NvimTree",
        "Outline",
        "minimap",
        "terminal",
        "qf",
        "Trouble",
      }
    end,
  },
  -- Misc & utilities
  {
    "andweeb/presence.nvim",
    config = function()
      require("presence"):setup({
        enable_line_number = true,
        main_image = "file",
        neovim_image_text = "How do I exit Neovim...?",
      })
    end,
    event = "BufWinEnter",
  },
  "ptethng/telescope-makefile",
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && yarn install",
    ft = { "markdown" },
  },
  -- "cheap-glitch/vim-v",
  {
    "nvim-treesitter/playground",
    after = "nvim-treesitter",
  },
  {
    "danymat/neogen",
    config = function()
      require("neogen").setup({
        enabled = true,
        input_after_comment = true, -- (default: true) automatic jump (with insert mode) on inserted annotation
        jump_map = "jn", -- The keymap in order to jump in the annotation fields (in insert mode)
        languages = {
          python = {
            template = {
              annotation_convention = "numpydoc",
            },
          },
        },
      })

      vim.api.nvim_set_keymap("n", "mm", "<cmd>Neogen<CR>", { silent = true })
    end,
    after = "nvim-treesitter",
  },
  {
    "tamton-aquib/dynamic-cursor.nvim",
    config = function()
      require("dynamic-cursor").setup({
        guicursor = "n-v-c:block-DynamicCursor,i-ci-ve:ver25-DynamicCursor,r-cr-o:hor25-DynamicCursor",
      })
    end,
    after = "nvim-treesitter",
  },
  {
    "lewis6991/impatient.nvim",
    rocks = "mpack",
  },
}

return M

-- vim: sw=2 sts=2 ts=2 noexpandtab
