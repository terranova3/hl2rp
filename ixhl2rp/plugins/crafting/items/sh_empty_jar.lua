
ITEM.name = "Plastic Jar"
ITEM.model = Model("models/props_lab/jar01b.mdl")
ITEM.description = "An empty jar, looks like there was once some vitamin supplement inside."
ITEM.width = 1
ITEM.height = 1
ITEM.price = 5
ITEM.category = "Crafting"
ITEM.rarity = "Common"
ITEM.noBusiness = true
-- Junk Items Dont stack
ITEM.tool = "lighter"
ITEM.breakdown = {
    [1] = {
        uniqueID = "chunk_of_plastic",
        amount = 1,
        data = {}
    }
}