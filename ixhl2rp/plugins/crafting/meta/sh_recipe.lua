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
RECIPE.isMastery = false
RECIPE.requirements = nil

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

-- Called when we need to know if a client can access a recipe.
function RECIPE:CanAccess(client)
	local character = client:GetCharacter()

	if (!character) then
		return false
	end

	if (inventory and inventory:HasItem("flashlight")) then
		return true
	end
	-- If this recipe is a mastery only recipe and the character doesn't have that mastery, then don't allow them to access it.
	if(self.isMastery and character:GetMastery() != self.profession) then
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

	for uniqueID, vars in pairs(self.requirements or {}) do
		local item = ix.item.list[uniqueID]

		if(!item) then
			return false
		end

		-- Grabbing all of the instances of this uniqueID in a character's inventory.
		local items = inventory:GetItemsByID(uniqueID)

		if(item.capacity) then
			local neededLiquid = vars.amount

			-- Iterate through all the liquid items to see if we have the liquid needed
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
		elseif(item.maxStack) then
			local neededStacks = vars.amount

			for k, v in pairs(items) do
				neededStacks = math.Clamp(neededStacks - v:GetData("stack", 0), 0, 9999)

				if(neededStacks == 0) then
					break
				end
			end

			if(neededStacks != 0) then
				return false
			end
		else
			if(!items[v.amount]) then
				return false
			end
		end
	end

	return true
end

-- Called after a recipe can be crafted and we need to remove the correct materials and add the result.
function RECIPE:OnCraft(client)

end

PLUGIN.meta.recipe = RECIPE
