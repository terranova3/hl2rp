
ITEM.name = "Dirty Water"
ITEM.model = Model("models/props_junk/glassjug01.mdl")
ITEM.description = "A plastic container of dirty water, its got major discoloration to it."
ITEM.width = 1
ITEM.height = 1
ITEM.price = 5
ITEM.category = "Crafting"
ITEM.noBusiness = true

ITEM.combine = function(item, targetItem)
    local client = item:GetOwner()
    local inventory = client:GetCharacter():GetInventory()

	if(targetItem.uniqueID == "water_purifytab") then
	   inventory:Add("unionwater", 2)
	end
end
