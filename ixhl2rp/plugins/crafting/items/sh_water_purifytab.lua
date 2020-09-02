
ITEM.name = "Civil-Approved Purfication Tablets"
ITEM.model = Model("models/mark2580/gtav/garage_stuff/oilbot02.mdl")
ITEM.description = "A plastic jar with large tablets, it has a biohazard symbol labled onto the jar."
ITEM.width = 1
ITEM.height = 1
ITEM.price = 5
ITEM.category = "Crafting"
ITEM.noBusiness = true

ITEM.combine = function(item, targetItem)
    local client = item:GetOwner()
    local inventory = client:GetCharacter():GetInventory()

	if(targetItem.uniqueID == "water_dirty") then
	   inventory:Add("unionwater", 2)
	   return true
	end
end