
ITEM.name = "Charcoal"
ITEM.model = Model("models/props_junk/rock001a.mdl")
ITEM.description = "Charcoal procuded from wood."
ITEM.width = 1
ITEM.height = 1
ITEM.price = 20
ITEM.category = "Crafting"
ITEM.rarity = "Common"
ITEM.noBusiness = true
ITEM.maxStack = 5;
ITEM.defaultStack = 1;

function ITEM:GetMaterial() 
    return "models/gibs/metalgibs/metal_gibs"
end 