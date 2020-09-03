
ITEM.name = "Empty Glass Bottle"
ITEM.model = Model("models/props_junk/garbage_glassbottle003a.mdl")
ITEM.description = "An empty glass bottle."
ITEM.width = 1
ITEM.height = 1
ITEM.price = 5
ITEM.category = "Crafting"
ITEM.rarity = "Common"
ITEM.noBusiness = true
-- Junk Items Dont stack
ITEM.tool = "cement_stone"
ITEM.breakdown = {
    [1] = {
        uniqueID = "scrap_glass",
        amount = 1,
        data = {}
    }
}