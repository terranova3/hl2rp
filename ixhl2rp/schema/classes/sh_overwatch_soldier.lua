CLASS.name = "Overwatch Soldier"
CLASS.faction = FACTION_OTA
CLASS.isDefault = true
CLASS.color = Color(150, 50, 50, 255)

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetModel("models/cultist/hl_a/vannila_combine/npc/combine_soldier.mdl")
	end
end

CLASS_OWS = CLASS.index
