ITEM.name = "Ration"
ITEM.model = Model("models/weapons/w_package.mdl")
ITEM.description = "A shrink-wrapped packet containing some food and money."
ITEM.contains = {
    [1] = {
        uniqueID = "union_apple",
        amount = 1,
        data = {}
    },
    [2] = {
        uniqueID = "union_water",
        amount = 1,
        data = {}
    },
    [3] = {
        uniqueID = "money",
        amount = 25,
        data = {}
    }
}