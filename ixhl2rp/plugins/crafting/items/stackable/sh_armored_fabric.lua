
ITEM.name = "Armored Fabric"
ITEM.model = Model("models/gibs/scanner_gib03.mdl")
ITEM.description = "An armored piece of cloth usually used to craft armored clothing."
ITEM.width = 1
ITEM.height = 1
ITEM.price = 100
ITEM.category = "Crafting"
ITEM.noBusiness = true
ITEM.maxStack = 5;
ITEM.defaultStack = 1;
ITEM.breakdown = {
    [1] = {
        uniqueID = "refined_metal",
        amount = 1,
        data = {}
    }
}