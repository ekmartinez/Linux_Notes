-- Lua formatting not working

return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")

	null_ls.setup({
	  sources = {
		require("none-ls.diagnostics.eslint_d"),
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.isort,
		null_ls.builtins.formatting.clang_format,

		null_ls.builtins.diagnostics.pylint,
		},
	})
	vim.keymap.set('n', '<leader>gf', vim.lsp.buf.format, {})
  end
}

-- builtins.formatting = formaters
-- builtins.diagnostics = linters
