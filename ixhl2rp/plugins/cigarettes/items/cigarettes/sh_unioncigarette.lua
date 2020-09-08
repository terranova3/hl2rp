--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local unlit = table.Copy(PLUGIN.pacData.unlit)
unlit[1]["children"][1]["self"]["Model"] = "models/phycitnew.mdl"

local lit = table.Copy(PLUGIN.pacData.lit)
lit[1]["children"][1]["self"]["Model"] = "models/phycitnew.mdl"

ITEM.name = "Approved Cigarette"
ITEM.model = Model("models/phycitnew.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Something resembling the original deliciously flavoured death-sticks of time past. It's okay."
ITEM.category = "Other"
ITEM.flag = "g"
ITEM.price = 3;
ITEM.time = 90
ITEM.pacData = unlit
ITEM.pacDataAlternate = lit

unlit = nil
lit = nil