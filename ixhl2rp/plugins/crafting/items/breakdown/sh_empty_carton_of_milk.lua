
ITEM.name = "Empty Carton of Milk"
ITEM.model = Model("models/props_junk/garbage_milkcarton002a.mdl")
ITEM.description = "An empty carton of milk."
ITEM.width = 1
ITEM.height = 1
ITEM.price = 5
ITEM.category = "Crafting"
ITEM.rarity = "Common"
ITEM.noBusiness = true
-- Junk Items Dont stack
ITEM.breakdown = {
    [1] = {
        uniqueID = "cardboard_scraps",
        amount = 1,
        data = {}
    }
}