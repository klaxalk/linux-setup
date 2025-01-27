lua << EOF
require("autoclose").setup({
 keys = {
     ["'"] = { escape = true, close = true, pair = "''", disabled_filetypes = {}, enabled_filetypes = {"cpp", "h", "hpp", "py"} },
     ['"'] = { escape = true, close = true, pair = '""', disabled_filetypes = {}, enabled_filetypes = {"cpp", "h", "hpp", "py"} },
     ['('] = { escape = true, close = true, pair = '()', disabled_filetypes = {}, enabled_filetypes = {"cpp", "h", "hpp", "py"} },
     ['{'] = { escape = true, close = true, pair = '{}', disabled_filetypes = {}, enabled_filetypes = {"cpp", "h", "hpp", "py"} },
     ['[]'] = { escape = true, close = true, pair = '[]', disabled_filetypes = {}, enabled_filetypes = {"cpp", "h", "hpp", "py"} },
     ['<'] = { escape = true, close = true, pair = '<>', disabled_filetypes = {}, enabled_filetypes = {"cpp", "h", "hpp", "py"} },
   },
})
EOF
