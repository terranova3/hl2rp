--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.perms = {}
ix.perms.stored = {}

function ix.perms.Register(category, name)
    if(!ix.perms.stored[category]) then
        ix.perms.stored[category] = {}
    end

    table.insert(ix.perms.stored[category], name)
end