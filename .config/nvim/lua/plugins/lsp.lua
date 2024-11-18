return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {},
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-copilot",
      dependencies = {
        "github/copilot.vim",
      },
    },
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        sources = {
          { name = "nvim_lsp" },
          { name = "copilot" },
        },
        mapping = cmp.mapping.preset.insert({
          ["<c-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
          ["<c-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
          ["<down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
          ["<up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
          ["<c-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
          ["<c-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
          ["<c-space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<c-e>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          },
          ["<cr>"] = cmp.mapping.confirm { select = true },
        }),
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = function()
      local map = function(type, key, value)
        vim.api.nvim_buf_set_keymap(0, type, key, value, { noremap = true, silent = true })
      end

      local custom_attach = function(client)
        -- require "completion".on_attach(client)
        -- require "diagnostic".on_attach(client)

        map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
        map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
        map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
        map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
        map("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
        map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
        map("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
        map("n", "<leader>gw", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
        map("n", "<leader>gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
        map("n", "<leader>ah", "<cmd>lua vim.lsp.buf.hover()<CR>")
        map("n", "<leader>af", "<cmd>lua vim.lsp.buf.code_action()<CR>")
        map("n", "<leader>ee", "<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>")
        map("n", "<leader>ar", "<cmd>lua vim.lsp.buf.rename()<CR>")
        map("n", "<leader>=", "<cmd>lua vim.lsp.buf.formatting()<CR>")
        map("n", "<leader>ai", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>")
        map("n", "<leader>ao", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>")
      end
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              on_attach = custom_attach,
            })
          end,
          ["lua_ls"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim" },
                  },
                },
              },
            })
          end,
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "isort", "black" },
          rust = { "rustfmt" },
          javascript = { "biome" },
          json = { "biome" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_format = "fallback",
        },
      })
    end,
  },
  {
    "zapling/mason-conform.nvim",
    config = function()
      require("mason-conform").setup({})
    end,
  },
}
