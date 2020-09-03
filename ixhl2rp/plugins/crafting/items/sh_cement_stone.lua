
ITEM.name = "Cement Stone"
ITEM.model = Model("models/props_junk/rock001a.mdl")
ITEM.description = "A cement stone from the sidewalk."
ITEM.width = 1
ITEM.height = 1
ITEM.price = 20
ITEM.category = "Crafting"
ITEM.rarity = "Common"
ITEM.noBusiness = true
-- No stack

-- function ITEM:Combine(targetItem)
--    local client = self:GetOwner()
 --   local inventory = client:GetCharacter():GetInventory()

  --  if(targetItem.uniqueID == "empty_glass_bottle") then
  --     inventory:Add("scrap_glass", 1)
  --     targetItem:Remove()
  --  end
--end