--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PLUGIN = PLUGIN
PLUGIN.meta = PLUGIN.meta or {}

local RECIPE = PLUGIN.meta.recipe or {}
RECIPE.__index = RECIPE
RECIPE.name = "undefined"
RECIPE.description = "undefined"
RECIPE.uniqueID = "undefined"
RECIPE.category = "Crafting"
RECIPE.profession = nil
RECIPE.mastery = false
RECIPE.blueprint = false
RECIPE.requirements = {}
RECIPE.station = nil
RECIPE.results = {}

-- Called when the name of the recipe is needed.
function RECIPE:GetName()
	return self.name
end

-- Called when the description of the recipe is needed.
function RECIPE:GetDescription()
	return self.description
end

-- Called when the skin of the recipe is needed.
function RECIPE:GetSkin()
	return self.skin
end

-- Called when the model of the recipe is needed.
function RECIPE:GetModel()
	return self.model
end

-- Returns the profession this recipe is attached to.
function RECIPE:GetProfession()
	return self.profession
end

-- Returns the results of a recipe
function RECIPE:GetResults()
	return self.results
end

-- Returns the uniqueid of a recipe.
function RECIPE:GetUniqueID()
	return self.uniqueID
end

-- Returns if a recipe is for blueprints only.
function RECIPE:GetBlueprint()
	return self.blueprint
end

-- Returns if a recipe is mastery only.
function RECIPE:GetMastery()
	return self.mastery
end

-- Returns the first result of a recipe array.
function RECIPE:GetFirstResult()
	for k, v in pairs(self.results) do
		return k, v
	end
end

-- Called when we need to know if a client can access a recipe.
function RECIPE:CanAccess(client)
	local character = client:GetCharacter()

	if (!character) then
		return false
	end

	-- If this recipe is a mastery only recipe and the character doesn't have that mastery, then don't allow them to access it.
	if(self.isMastery and character:GetMastery() != self.profession) then
		return false, "Mastery"
	end

	if(self.blueprint and !character:HasBlueprint(self.blueprint)) then
		return false, "Blueprint"
	end

	return true
end

-- Called when we need to get the requirements string of a recipe.
function RECIPE:GetRequirements()
	local string = ""

	for k, v in pairs(self.requirements) do
		local item = ix.item.list[k]
		
		if(item) then
			if(item.capacity) then
				string = string .. string.format("%smL %s", v, item.name)
			elseif(item.maxStack) then
				string = string .. string.format("%s (%s)", item.name, v)
			else
				if(v > 1) then
					string = string .. v .. "x " .. item.name
				else
					string = string .. item.name
				end
			end
		end

		string = string .. "\n"
	end

	return string
end

-- Returns the tools required for this recipe as a single string.
function RECIPE:GetTools()
	local tools = table.Copy(self.tools) or {}
	local string = ""
	
	if(self.station and ix.stations.Get(self.station)) then
		table.insert(tools, ix.stations.Get(self.station).name)
	end

	for k, v in pairs(tools) do
		local item = ix.item.list[v]

		if(item) then
			string = string .. item.name
		else
			string = string .. v
		end

		string = string .. "\n"
	end

	return string
end

-- Called when checking if a character has liquid items that a recipe requires.
function RECIPE:HaveLiquid(value, uniqueID, inventory)
	if(CLIENT and !inventory) then
		inventory = LocalPlayer():GetCharacter():GetInventory()
	end

	local items = inventory:GetItemsByUniqueID(uniqueID)
	local neededLiquid = value

	for k, v in pairs(items) do
		neededLiquid = math.Clamp(neededLiquid - v:GetData("currentAmount", 0), 0, 9999)

		-- If we have all the liquid we needed, we no longer need to iterate.
		if(neededLiquid == 0) then
			break
		end
	end

	if(neededLiquid != 0) then
		return false
	end

	return true
end

-- Called when checking if a character has stackable items that a recipe requires.
function RECIPE:HaveStackables(value, uniqueID, inventory)
	if(CLIENT and !inventory) then
		inventory = LocalPlayer():GetCharacter():GetInventory()
	end

	local items = inventory:GetItemsByUniqueID(uniqueID)
	local neededStacks = value

	for k, v in pairs(items) do
		neededStacks = math.Clamp(neededStacks - v:GetData("stack", 0), 0, 9999)

		if(neededStacks == 0) then
			break
		end
	end
	
	if(neededStacks != 0) then
		return false
	end

	return true
end

-- Called when checking if a character has regular items that a recipe requires.
function RECIPE:HaveItems(value, uniqueID, inventory)
	if(CLIENT and !inventory) then
		inventory = LocalPlayer():GetCharacter():GetInventory()
	end

	local items = inventory:GetItemsByUniqueID(uniqueID)

	if(!items[value]) then
		return false
	end

	return true
end

-- Called when we need to see if a client has the correct materials to finish a recipe.
function RECIPE:CanCraft(client)
	local character = client:GetCharacter()
	local inventory = character and character:GetInventory()

	if (!character or !inventory) then
		return false
	end

	if(self:GetMastery() and !character:GetMastery(self:GetProfession())) then
		return false, string.format("You require a mastery in the %s profession to use this recipe.", self:GetProfession())
	end

	if(self:GetBlueprint() and !character:HasBlueprint(self:GetUniqueID())) then
		return false, "You don't have the blueprint for this recipe unlocked!"
	end

	for k, v in pairs(self.tools or {}) do
		local item = ix.item.list[v]

		if(!item) then
			return false, "Internal error! A tool required for this recipe doesn't exist."
		end

		if(!character:HasTool(item)) then
			return false, string.format("You don't have the %s tool in your inventory.", item:GetName())
		end
	end

	if(self.station) then
		local station = ix.stations.Get(self.station)
		
		if(station and !character:IsNearEnt(station.uniqueID)) then
			return false, string.format("You need to be near the %s entity for this recipe to work.", station.name)
		end
	end

	for uniqueID, value in pairs(self.requirements or {}) do
		local item = ix.item.list[uniqueID]

		-- todo: if an item doesn't exist we just shouldn't register the recipe.
		if(!item) then
			return false, "Internal error! An item required for this recipe doesn't exist."
		end

		if(item.capacity and !self:HaveLiquid(value, uniqueID, inventory)) then
			return false, string.format("You're missing the required liquid for %s.", item.name)
		elseif(item.maxStack and !self:HaveStackables(value, uniqueID, inventory)) then
			return false, string.format("You don't have the right amount of %s!", item.name)
		elseif(!self:HaveItems(value, uniqueID, inventory)) then
			return false, string.format("You need more %s.", item.name)
		end
	end

	return true
end

if(SERVER) then
	-- Called after a recipe can be crafted and we need to remove the correct materials and add the result.
	function RECIPE:OnCraft(client)
		local character = client:GetCharacter()
		local inventory = character and character:GetInventory()

		if (!character or !inventory) then
			return false
		end

		-- Removing all the recipe requirements from the player
		for uniqueID, value in pairs(self.requirements or {}) do
			local item = ix.item.list[uniqueID]

			if(!item) then
				return false
			end

			-- Grabbing all of the instances of this uniqueID in a character's inventory.
			local items = inventory:GetItemsByUniqueID(uniqueID)

			if(item.capacity) then
				local neededLiquid = value

				-- Iterate through all the liquid items to see if we have the liquid needed
				for k, v in pairs(items) do
					if(v:GetData("currentAmount", 0) >= neededLiquid) then
						v:SetData("currentAmount", v:GetData("currentAmount") - neededLiquid)
					else
						neededLiquid = neededLiquid - v:GetData("currentAmount", 0)
						v:SetData("currentAmount", 0)
					end

					if(neededLiquid <= 0) then
						break
					end
				end
			elseif(item.maxStack) then
				local neededStacks = value

				for k, v in pairs(items) do
					if(v:GetStacks() > neededStacks) then
						v:SetData("stacks", v:GetStacks() - neededStacks)
					else
						neededStacks = neededStacks - (v:GetStacks() or 0)
						v:Remove()
					end

					if(neededStacks <= 0) then
						break
					end
				end
			else
				for k, v in pairs(items) do
					v:Remove()
				end
			end
		end

		-- Add the resultant items from the recipe into the player's inventory.
		for k, v in pairs(self.results or {}) do
			inventory:Add(k, (v or 1))
		end
	end
end

PLUGIN.meta.recipe = RECIPE
