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


function GetMaterial(model)
	model = model:gsub("\\", "/")

	local path = "materials/spawnicons/" .. model:sub(1, #model - 4) .. ".png"
	local material = Material(path, "smooth")

	-- we don't have a cached spawnicon texture, so we need to forcefully generate one
	if (material:IsError()) then
		local renderer = vgui.Create("ModelImage")
		renderer:SetVisible(false)
		renderer:SetModel(model)
		renderer:RebuildSpawnIcon()

		-- this is the only way to get a callback for generated spawn icons, it's bad but it's only done once
		hook.Add("SpawniconGenerated", "terranova", function(lastModel, filePath, modelsLeft)
			filePath = filePath:gsub("\\", "/"):lower()

			if (filePath == path) then
				hook.Remove("SpawniconGenerated", "terranova")

				material = Material(filePath, "smooth")
				renderer:Remove()
			end
		end)
	end

	return path
end

spawnmenu.AddContentType("helix-item", function(container, itemData)
	if (not itemData.name) then return end

	local icon = vgui.Create("ContentIcon", container)
	icon:SetContentType("helix-item")
	icon:SetName(itemData.name)
	icon:SetMaterial(GetMaterial(itemData:GetModel()))

	icon.DoClick = function()
		net.Start("adminSpawnItem")
			net.WriteString(itemData.name)
		net.SendToServer()
		surface.PlaySound("buttons/button14.wav")
	end

	if (IsValid(container)) then
		container:Add(icon)
	end

	return icon
end)