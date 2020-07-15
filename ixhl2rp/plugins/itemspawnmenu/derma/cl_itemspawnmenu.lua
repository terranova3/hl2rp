spawnmenu.AddCreationTab("Helix Spawn Menu", function()
	local ctrl = vgui.Create("SpawnmenuContentPanel")
	local tree = ctrl.ContentNavBar.Tree
	local categories = {}

	for _, itemData in pairs(ix.item.list) do
		local category = itemData.category:sub(1, 1):upper() .. itemData.category:sub(2)
		
		if (!categories[category]) then
			categories[category] = {}
		end
		
		categories[category][itemData.uniqueID] = itemData
	end
	
	
	for category, itemTable in SortedPairs(categories) do
		local node = tree:AddNode(category)
		
		node.DoPopulate = function(self)
			-- If we've already populated it - forget it.
			if (self.SpawnPanel) then return end
			-- Create the container panel
			self.SpawnPanel = vgui.Create("ContentContainer", ctrl)
			self.SpawnPanel:SetVisible(false)
			self.SpawnPanel:SetTriggerSpawnlistChange(false)

			for itemID, itemData in SortedPairsByMemberValue(itemTable, "name") do
				spawnmenu.CreateContentIcon("helix-item", self.SpawnPanel, itemData)
			end
		end
		
		node.DoClick = function(self)
			self:DoPopulate()
			ctrl:SwitchPanel(self.SpawnPanel)
		end
	end

	return ctrl
end, "icon16/box.png", 1000)

spawnmenu.AddContentType("helix-item", function(container, itemData)
	if (not itemData.name) then return end

	local icon = vgui.Create("ContentIcon", container)
	icon:SetContentType("helix-item")
	icon:SetName(itemData.name)

	icon.DoClick = function()
		LocalPlayer():ConCommand("ix dropitem " .. itemData.uniqueID)
	end

	icon.OpenMenu = function(icon)
		local menu = DermaMenu()

		menu:AddOption("Add to inventory", function()
			LocalPlayer():ConCommand("ix chargiveitem \"" .. LocalPlayer():GetName() .."\" " .. itemData.uniqueID)
		end):SetImage("icon16/cart_put.png")

		menu:Open()
	end

	if (IsValid(container)) then
		container:Add(icon)
	end

	return icon
end)