ITEM.name = "Water Processing Box"
ITEM.model = Model("models/props_junk/cardboard_box004a.mdl")
ITEM.description = "A small labled package containing all the items for UU water processing."
ITEM.noBusiness = true
ITEM.contains = {
    [1] = {
        uniqueID = "water_dirty",
        amount = 1,
        data = {}
    },
    [2] = {
        uniqueID = "water_purifytab",
        amount = 1,
        data = {}
    }
}