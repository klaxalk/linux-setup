lua << EOF
require("autoclose").setup({
 keys = {
     ["'"] = { escape = true, close = true, pair = "''", disabled_filetypes = {}, enabled_filetypes = {"cpp", "h", "hpp", "py"} },
     ['"'] = { escape = true, close = true, pair = '""', disabled_filetypes = {}, enabled_filetypes = {"cpp", "h", "hpp", "py"} },
     ['('] = { escape = true, close = true, pair = '()', disabled_filetypes = {}, enabled_filetypes = {"cpp", "h", "hpp", "py"}, disable_command_mode = true},
     ['{'] = { escape = true, close = true, pair = '{}', disabled_filetypes = {}, enabled_filetypes = {"cpp", "h", "hpp", "py"} },
     ['[]'] = { escape = true, close = true, pair = '[]', disabled_filetypes = {}, enabled_filetypes = {"cpp", "h", "hpp", "py"} },
     ['<'] = { escape = true, close = true, pair = '<>', disabled_filetypes = {}, enabled_filetypes = {"cpp", "h", "hpp", "py"} },
     ['`'] = { escape = true, close = true, pair = '``', disabled_filetypes = {}, enabled_filetypes = {"sh", "bash"} },
     ['<<'] = { escape = true, close = true, pair = '<<>>', disabled_filetypes = {"cpp", "h", "hpp"}, enabled_filetypes = {} },
   },
})
EOF
