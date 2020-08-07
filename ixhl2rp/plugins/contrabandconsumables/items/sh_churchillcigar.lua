--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Churchill Cigar"
ITEM.model = Model("models/polievka/cigar.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Churchill Cigars for the premium asshole, or gun-toting badass.."
ITEM.category = "Contraband"
ITEM.price = 20;
ITEM.flag = "G"
ITEM.functions.Smoke = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:RestoreStamina(24)
	end
}

