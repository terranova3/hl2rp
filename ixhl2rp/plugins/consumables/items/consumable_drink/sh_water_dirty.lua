--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]
ITEM.capacity = 375
ITEM.restoreStamina = -40;
ITEM.name = "Dirty Water"
ITEM.model = Model("models/props_junk/glassjug01.mdl")
ITEM.description = "A plastic container of dirty water, its got major discoloration to it."
ITEM.width = 1
ITEM.height = 1
ITEM.price = 5
ITEM.category = "Crafting"
ITEM.noBusiness = true
ITEM.tool = "water_filter"
ITEM.breakdown = {
    [1] = {
        uniqueID = "bottleofwater",
        amount = 1,
        data = {}
    }
}

function ITEM:Combine(targetItem)
    local client = self.player
    local inventory = client:GetCharacter():GetInventory()

	if(targetItem.uniqueID == "water_purifytab") then
	   inventory:Add("unionwater", 2)
	   return true
	end
end

ITEM.dropSound = {
"terranova/ui/movingalcohol1.wav",
"terranova/ui/movingalcohol2.wav",
"terranova/ui/movingalcohol3.wav",
}
