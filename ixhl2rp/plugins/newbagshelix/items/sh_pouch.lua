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
	icon = "models/props_junk/garbage_bag001a.mdl",
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

if (CLIENT) then
	function ITEM:PaintOver(item, width, height)
		local panel = ix.gui["inv" .. item:GetData("id", "")]

		if (!IsValid(panel)) then
			return
		end

		if (vgui.GetHoveredPanel() == self) then
			panel:SetHighlighted(true)
		else
			panel:SetHighlighted(false)
		end
	end
end

-- Called when a new instance of this item has been made.
function ITEM:OnInstanced(invID, x, y)
	local inventory = ix.item.inventories[invID]

	ix.item.NewInv(inventory and inventory.owner or 0, self.uniqueID, function(inv)
		local client = inv:GetOwner()

		inv.vars.isBag = self.uniqueID
		self:SetData("id", inv:GetID())

		if (IsValid(client)) then
			inv:AddReceiver(client)
		end
	end)
end

function ITEM:GetInventory()
	local index = self:GetData("id")

	if (index) then
		return ix.item.inventories[index]
	end
end

ITEM.GetInv = ITEM.GetInventory

-- Called when the item first appears for a client.
function ITEM:OnSendData()
	local index = self:GetData("id")

	if (index) then
		local inventory = ix.item.inventories[index]

		if (inventory) then
			inventory.vars.isBag = self.uniqueID
			inventory:Sync(self.player)
			inventory:AddReceiver(self.player)
		else
			local owner = self.player:GetCharacter():GetID()

			ix.item.RestoreInv(self:GetData("id"), self.invWidth, self.invHeight, function(inv)
				inv.vars.isBag = self.uniqueID
				inv:SetOwner(owner, true)

				if (!inv.owner) then
					return
				end

				for client, character in ix.util.GetCharacters() do
					if (character:GetID() == inv.owner) then
						inv:AddReceiver(client)
						break
					end
				end
			end)
		end
	else
		ix.item.NewInv(self.player:GetCharacter():GetID(), self.uniqueID, function(inv)
			self:SetData("id", inv:GetID())
		end)
	end
end

ITEM.postHooks.drop = function(item, result)
	local index = item:GetData("id")

	local query = mysql:Update("ix_inventories")
		query:Update("character_id", 0)
		query:Where("inventory_id", index)
	query:Execute()

	net.Start("ixBagDrop")
		net.WriteUInt(index, 32)
	net.Send(item.player)
end

if (CLIENT) then
	net.Receive("ixBagDrop", function()
		local index = net.ReadUInt(32)
		local panel = ix.gui["inv"..index]

		if (panel and panel:IsVisible()) then
			panel:Close()
		end
	end)
end

-- Called before the item is permanently deleted.
function ITEM:OnRemoved()
	local index = self:GetData("id")

	if (index) then
		local query = mysql:Delete("ix_items")
			query:Where("inventory_id", index)
		query:Execute()

		query = mysql:Delete("ix_inventories")
			query:Where("inventory_id", index)
		query:Execute()
	end
end

-- Called when the item should tell whether or not it can be transfered between inventories.
function ITEM:CanTransfer(oldInventory, newInventory)
	local index = self:GetData("id")

	if (newInventory) then
		if (newInventory.vars and newInventory.vars.isBag) then
			return false
		end

		local index2 = newInventory:GetID()

		if (index == index2) then
			return false
		end

		for _, v in pairs(self:GetInventory():GetItems()) do
			if (v:GetData("id") == index2) then
				return false
			end
		end
	end

	return !newInventory or newInventory:GetID() != oldInventory:GetID() or newInventory.vars.isBag
end

function ITEM:OnTransferred(curInv, inventory)
	local bagInventory = self:GetInventory()

	if (isfunction(curInv.GetOwner)) then
		local owner = curInv:GetOwner()

		if (IsValid(owner)) then
			bagInventory:RemoveReceiver(owner)
		end
	end

	if (isfunction(inventory.GetOwner)) then
		local owner = inventory:GetOwner()

		if (IsValid(owner)) then
			bagInventory:AddReceiver(owner)
			bagInventory:SetOwner(owner)
		end
	else
		-- it's not in a valid inventory so nobody owns this bag
		bagInventory:SetOwner(nil)
	end
end

-- Called after the item is registered into the item tables.
function ITEM:OnRegistered()
	ix.item.RegisterInv(self.uniqueID, self.invWidth, self.invHeight, true)
end

-- Mike Jittlov's "Meriday in the Morning"
-- 
--                        8888  8888888
--                   888888888888888888888888
--                8888:::8888888888888888888888888
--              8888::::::8888888888888888888888888888
--             88::::::::888:::8888888888888888888888888
--           88888888::::8:::::::::::88888888888888888888
--         888 8::888888::::::::::::::::::88888888888   888
--            88::::88888888::::m::::::::::88888888888    8
--          888888888888888888:M:::::::::::8888888888888
--         88888888888888888888::::::::::::M88888888888888
--         8888888888888888888888:::::::::M8888888888888888
--          8888888888888888888888:::::::M888888888888888888
--         8888888888888888::88888::::::M88888888888888888888
--       88888888888888888:::88888:::::M888888888888888   8888
--      88888888888888888:::88888::::M::;o*M*o;888888888    88
--     88888888888888888:::8888:::::M:::::::::::88888888    8
--    88888888888888888::::88::::::M:;:::::::::::888888888
--   8888888888888888888:::8::::::M::aAa::::::::M8888888888       8
--   88   8888888888::88::::8::::M:::::::::::::888888888888888 8888
--  88  88888888888:::8:::::::::M::::::::::;::88:88888888888888888
--  8  8888888888888:::::::::::M::"@@@@@@@"::::8w8888888888888888
--   88888888888:888::::::::::M:::::"@a@":::::M8i888888888888888
--  8888888888::::88:::::::::M88:::::::::::::M88z88888888888888888
-- 8888888888:::::8:::::::::M88888:::::::::MM888!888888888888888888
-- 888888888:::::8:::::::::M8888888MAmmmAMVMM888*88888888   88888888
-- 888888 M:::::::::::::::M888888888:::::::MM88888888888888   8888888
-- 8888   M::::::::::::::M88888888888::::::MM888888888888888    88888
--  888   M:::::::::::::M8888888888888M:::::mM888888888888888    8888
--   888  M::::::::::::M8888:888888888888::::m::Mm88888 888888   8888
--    88  M::::::::::::8888:88888888888888888::::::Mm8   88888   888
--    88  M::::::::::8888M::88888::888888888888:::::::Mm88888    88
--    8   MM::::::::8888M:::8888:::::888888888888::::::::Mm8     4
--        8M:::::::8888M:::::888:::::::88:::8888888::::::::Mm    2
--       88MM:::::8888M:::::::88::::::::8:::::888888:::M:::::M
--      8888M:::::888MM::::::::8:::::::::::M::::8888::::M::::M
--     88888M:::::88:M::::::::::8:::::::::::M:::8888::::::M::M
--    88 888MM:::888:M:::::::::::::::::::::::M:8888:::::::::M:
--    8 88888M:::88::M:::::::::::::::::::::::MM:88::::::::::::M
--      88888M:::88::M::::::::::*88*::::::::::M:88::::::::::::::M
--     888888M:::88::M:::::::::88@@88:::::::::M::88::::::::::::::M
--     888888MM::88::MM::::::::88@@88:::::::::M:::8::::::::::::::*8
--     88888  M:::8::MM:::::::::*88*::::::::::M:::::::::::::::::88@@
--     8888   MM::::::MM:::::::::::::::::::::MM:::::::::::::::::88@@
--      888    M:::::::MM:::::::::::::::::::MM::M::::::::::::::::*8
--      888    MM:::::::MMM::::::::::::::::MM:::MM:::::::::::::::M
--       88     M::::::::MMMM:::::::::::MMMM:::::MM::::::::::::MM
--       88    MM:::::::::MMMMMMMMMMMMMMM::::::::MMM::::::::MMM
--         88    MM::::::::::::MMMMMMM::::::::::::::MMMMMMMMMM
--          88   8MM::::::::::::::::::::::::::::::::::MMMMMM
--           8   88MM::::::::::::::::::::::M:::M::::::::MM
--               888MM::::::::::::::::::MM::::::MM::::::MM
--              88888MM:::::::::::::::MMM:::::::mM:::::MM
--              888888MM:::::::::::::MMM:::::::::MMM:::M
--             88888888MM:::::::::::MMM:::::::::::MM:::M
--            88 8888888M:::::::::MMM::::::::::::::M:::M
--            8  888888 M:::::::MM:::::::::::::::::M:::M:
--               888888 M::::::M:::::::::::::::::::M:::MM
--              888888  M:::::M::::::::::::::::::::::::M:M
--              888888  M:::::M:::::::::@::::::::::::::M::M
--              88888   M::::::::::::::@@:::::::::::::::M::M
--             88888   M::::::::::::::@@@::::::::::::::::M::M
--            88888   M:::::::::::::::@@::::::::::::::::::M::M
--           88888   M:::::m::::::::::@::::::::::Mm:::::::M:::M
--           8888   M:::::M:::::::::::::::::::::::MM:::::::M:::M
--          8888   M:::::M:::::::::::::::::::::::MMM::::::::M:::M
--         888    M:::::M:::::::::::::::::::::::MMM:::::::::M::::M
--       8888    MM::::Mm:::::::::::::::::::::MMMM:::::::::m::m:::M
--     888      M:::::M::::::::::::::::::::MMM::::::::::::M::mm:::M
--   8888       MM:::::::::::::::::::::::::MM:::::::::::::mM::MM:::M: Ayreborne was here.
--              M:::::::::::::::::::::::::M:::::::::::::::mM::MM:::Mm
--             MM::::::m:::::::::::::::::::::::::::::::::::M::MM:::MM
--             M::::::::M:::::::::::::::::::::::::::::::::::M::M:::MM
--            MM:::::::::M:::::::::::::M:::::::::::::::::::::M:M:::MM
--            M:::::::::::M88:::::::::M:::::::::::::::::::::::MM::MMM
--            M::::::::::::8888888888M::::::::::::::::::::::::MM::MM
--            M:::::::::::::88888888M:::::::::::::::::::::::::M::MM
--            M::::::::::::::888888M:::::::::::::::::::::::::M::MM
--            M:::::::::::::::88888M:::::::::::::::::::::::::M:MM
--            M:::::::::::::::::88M::::::::::::::::::::::::::MMM
--            M:::::::::::::::::::M::::::::::::::::::::::::::MMM
--            MM:::::::::::::::::M::::::::::::::::::::::::::MMM
--             M:::::::::::::::::M::::::::::::::::::::::::::MMM
--             MM:::::::::::::::M::::::::::::::::::::::::::MMM
--              M:::::::::::::::M:::::::::::::::::::::::::MMM
--              MM:::::::::::::M:::::::::::::::::::::::::MMM
--               M:::::::::::::M::::::::::::::::::::::::MMM
--               MM:::::::::::M::::::::::::::::::::::::MMM
--                M:::::::::::M:::::::::::::::::::::::MMM
--                MM:::::::::M:::::::::::::::::::::::MMM
--                 M:::::::::M::::::::::::::::::::::MMM
--                 MM:::::::M::::::::::::::::::::::MMM
--                  MM::::::M:::::::::::::::::::::MMM
--                  MM:::::M:::::::::::::::::::::MMM
--                   MM::::M::::::::::::::::::::MMM
--                   MM:::M::::::::::::::::::::MMM
--                    MM::M:::::::::::::::::::MMM
--                    MM:M:::::::::::::::::::MMM
--                    MMM::::::::::::::::::MMM
--                     MM::::::::::::::::::MMM
--                      M:::::::::::::::::MMM
--                     MM::::::::::::::::MMM
--                     MM:::::::::::::::MMM
--                     MM::::M:::::::::MMM:
--                     mMM::::MM:::::::MMMM
--                      MMM:::::::::::MMM:M
--                      mMM:::M:::::::M:M:M
--                       MM::MMMM:::::::M:M
--                       MM::MMM::::::::M:M
--                       mMM::MM::::::::M:M
--                        MM::MM:::::::::M:M
--                        MM::MM::::::::::M:m
--                        MM:::M:::::::::::MM
--                        MMM:::::::::::::::M:
--                        MMM:::::::::::::::M:
--                        MMM::::::::::::::::M
--                        MMM::::::::::::::::M
--                        MMM::::::::::::::::Mm
--                         MM::::::::::::::::MM
--                         MMM:::::::::::::::MM
--                         MMM:::::::::::::::MM
--                         MMM:::::::::::::::MM
--                         MMM:::::::::::::::MM
--                          MM::::::::::::::MMM
--                          MMM:::::::::::::MM
--                          MMM:::::::::::::MM
--                          MMM::::::::::::MM
--                           MM::::::::::::MM
--                           MM::::::::::::MM
--                           MM:::::::::::MM
--                           MMM::::::::::MM
--                           MMM::::::::::MM
--                            MM:::::::::MM
--                            MMM::::::::MM
--                            MMM::::::::MM
--                             MM::::::::MM
--                             MMM::::::MM
--                             MMM::::::MM
--                              MM::::::MM
--                              MM::::::MM
--                               MM:::::MM
--                               MM:::::MM:
--                               MM:::::M:M
--                               MM:::::M:M
--                               :M::::::M:
--                              M:M:::::::M
--                             M:::M::::::M
--                            M::::M::::::M
--                           M:::::M:::::::M
--                          M::::::MM:::::::M
--                          M:::::::M::::::::M
--                          M;:;::::M:::::::::M
--                          M:m:;:::M::::::::::M
--                          MM:m:m::M::::::::;:M
--                           MM:m::MM:::::::;:;M
--                            MM::MMM::::::;:m:M
--                             MMMM MM::::m:m:MM
--                                   MM::::m:MM
--                                    MM::::MM
--                                     MM::MM
--                                      MMMM
