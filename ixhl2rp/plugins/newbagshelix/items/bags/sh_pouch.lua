if (SERVER) then
	util.AddNetworkString("ixBagDrop")
end

ITEM.name = "Pouch"
ITEM.description = "A pouch to hold items."
ITEM.model = "models/props_junk/garbage_bag001a.mdl"
ITEM.category = "Storage"
ITEM.price = 30
ITEM.width = 1
ITEM.height = 1
ITEM.invWidth = 2
ITEM.invHeight = 1
ITEM.isBag = true
ITEM.functions.View = {
	icon = "icon16/briefcase.png",
	OnClick = function(item)
		local index = item:GetData("id", "")

		if (index) then
			local panel = ix.gui["inv"..index]
			local inventory = ix.item.inventories[index]
			local parent = IsValid(ix.gui.menuInventoryContainer) and ix.gui.menuInventoryContainer or ix.gui.openedStorage

			if (IsValid(panel)) then
				panel:Remove()
			end

			if (inventory and inventory.slots) then
				panel = vgui.Create("ixInventory", IsValid(parent) and parent or nil)
				panel:SetInventory(inventory)
				panel:ShowCloseButton(true)
				panel:SetTitle(item.GetName and item:GetName() or L(item.name))

				if (parent != ix.gui.menuInventoryContainer) then
					panel:Center()

					if (parent == ix.gui.openedStorage) then
						panel:MakePopup()
					end
				else
					panel:MoveToFront()
				end

				ix.gui["inv"..index] = panel
			else
				ErrorNoHalt("[Helix] Attempt to view an uninitialized inventory '"..index.."'\n")
			end
		end

		return false
	end,
	OnCanRun = function(item)
		return !IsValid(item.entity) and item:GetData("id") and !IsValid(ix.gui["inv" .. item:GetData("id", "")])
	end
}