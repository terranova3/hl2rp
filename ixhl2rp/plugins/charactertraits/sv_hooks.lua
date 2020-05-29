--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;
PLUGIN.categories = {
	"physical",
	"intelligence",
	"mentality",
	"philosophy"
}

function PLUGIN:OnLoaded()
	for _, path in ipairs(self.paths or {}) do
		for _, v in pairs(self.categories) do
			ix.traits.LoadFromDir(path.."/traits/" .. v)
		end
	end
	
	MsgC(Color(25, 235, 25), "[Character Traits] Loaded " .. ix.traits.indices .. " different traits!\n")
end

-- Calls the OnCharacterCreated hook of any traits the player has.
function PLUGIN:OnCharacterCreated(client, character) 
	ix.traits.CallHook("OnCharacterCreated", client, character); 
end;