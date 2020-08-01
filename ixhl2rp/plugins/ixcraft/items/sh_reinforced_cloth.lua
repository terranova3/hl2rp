
ITEM.name = "Reinforced Cloth"
ITEM.model = Model("models/gibs/scanner_gib03.mdl")
ITEM.description = "An armored piece of cloth usually used to craft armored clothing. Can be worn with your clothes to provide some protection."
ITEM.width = 1
ITEM.height = 1
ITEM.price = 125
ITEM.category = "Crafting"
ITEM.rarity = "Rare"
ITEM.noBusiness = true

ITEM.functions.Apply = {
	name = "Use",
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetArmor(math.min(client:Armor() + 10, client:GetMaxArmor))
	end
}
