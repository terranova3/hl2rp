--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

FACTION.name = "Vortigaunt"
FACTION.description = "An alien race not from this planet."
FACTION.color = Color(0, 255, 0, 255);
FACTION.runSounds = {[0] = "NPC_Vortigaunt.FootstepLeft", [1] = "NPC_Vortigaunt.FootstepRight"}
FACTION.walkSounds = FACTION.runSounds
FACTION.isDefault = false
FACTION.models = {
	"models/vortigaunt.mdl"
}

function FACTION:OnTransferred(client)
	local character = client:GetCharacter()
	character:SetModel(self.models[1])
end

FACTION_VORT = FACTION.index
