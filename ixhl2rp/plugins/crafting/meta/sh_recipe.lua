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

function RECIPE:GetName()
	return self.name
end

function RECIPE:GetDescription()
	return self.description
end

function RECIPE:GetSkin()
	return self.skin
end

function RECIPE:GetModel()
	return self.model
end

function RECIPE:CanAccess(client)
	local character = client:GetCharacter()

	if (!character) then
		return false
	end

	-- If this recipe is a mastery only recipe and the character doesn't have that mastery, then don't allow them to access it.
	if(self.isMastery and character:GetMastery() != self.profession) then
		return false
	end

	return true
end

PLUGIN.meta.recipe = RECIPE
