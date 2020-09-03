
ITEM.name = "Empty Box"
ITEM.model = Model("models/props_lab/box01b.mdl")
ITEM.description = "An empty box used for holding various ammunition."
ITEM.width = 1
ITEM.height = 1
ITEM.price = 10
ITEM.category = "Crafting"
ITEM.rarity = "Common"
ITEM.noBusiness = true
-- No Stack
ITEM.breakdown = {
    [1] = {
        uniqueID = "cardboard_scraps",
        amount = 1,
        data = {}
    }
}