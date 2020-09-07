--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.charPanel = ix.charPanel or {}
ix.charPanels = ix.charPanels or {
	[0] = {}
}

function ix.charPanel.CreatePanel(id)
    local panel = setmetatable({id = id, slots = {}, vars = {}, receivers = {}}, ix.meta.charPanel)
        ix.charPanels[id] = panel

    return panel
end