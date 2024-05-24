local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup({
    settings={
        save_on_toggle = true,
        sync_on_ui_close = true,
    }
})
-- REQUIRED

vim.keymap.set("n", "<A-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end) -- open quick meny
vim.keymap.set("n", "<A-m>", function() harpoon:list():add() end) -- add buffer to default list

for i=1, 9 do
    vim.keymap.set("n", string.format("<A-%s>", i), function() harpoon:list():select(i) end) -- select n'th element from default list
end

-- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set("n", "<A-S-P>", function() harpoon:list():prev() end)
-- vim.keymap.set("n", "<A-S-N>", function() harpoon:list():next() end)
