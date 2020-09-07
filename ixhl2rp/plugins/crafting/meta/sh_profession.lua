--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PLUGIN = PLUGIN
PLUGIN.meta = PLUGIN.meta or {}

local PROFESSION = PLUGIN.meta.recipe or {}
PROFESSION.__index = PROFESSION
PROFESSION.name = "undefined"
PROFESSION.description = "undefined"
PROFESSION.uniqueID = "undefined"
PROFESSION.mastery = true
PROFESSION.enabled = true

-- Called when the name of a profession is needed.
function PROFESSION:GetName()
	return self.name
end

function PROFESSION:IsEnabled()
	return self.enabled
end

-- Called when the description of a profession is needed.
function PROFESSION:GetDescription()
	return self.description
end

-- Called when we need to know if a profession should show in the crafting menu
function PROFESSION:ShouldDisplay()
	return self.mastery
end

-- Returns the profession's color.
function PROFESSION:GetColor()
	return self.color or Color(255,255,255,255)
end

-- Called as a helper function to access a method tied to the specific profession object.
function PROFESSION:Call(method, client, ...)
	local oldPlayer = self.player

	self.player = client or self.player

	if (isfunction(self[method])) then
		local results = {self[method](self, ...)}

		self.player = nil

		return unpack(results)
	end

	self.player = oldPlayer
end

PLUGIN.meta.profession = PROFESSION
