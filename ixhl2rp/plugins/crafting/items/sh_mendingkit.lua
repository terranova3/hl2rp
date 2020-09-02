
ITEM.name = "Armour Mending Kit"
ITEM.model = Model("models/Items/battery.mdl")
ITEM.description = "Various tools to repair ballistic armour."
ITEM.category = "Medical"
ITEM.price = 35
ITEM.flag = "Z"

ITEM.functions.Apply = {
	sound = "items/battery_pickup.wav",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetArmor(math.min(client:Armor() + 20, client:GetMaxArmor()))
	end
}
