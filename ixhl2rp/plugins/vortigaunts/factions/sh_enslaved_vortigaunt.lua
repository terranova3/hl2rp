--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

FACTION.name = "Enslaved Vortigaunt"
FACTION.description = "An alien race not from this planet."
FACTION.color = Color(0, 255, 200, 255);
FACTION.runSounds = {[0] = "NPC_Vortigaunt.FootstepLeft", [1] = "NPC_Vortigaunt.FootstepRight"}
FACTION.weapons = {"ix_vortsweep"}
FACTION.walkSounds = FACTION.runSounds
FACTION.isDefault = false
FACTION.models = {
	"models/vortigaunt_slave.mdl"
}

function FACTION:OnTransferred(client)
	local character = client:GetCharacter()
	character:SetModel(self.models[1])
end

FACTION_VORTSLAVE = FACTION.index
