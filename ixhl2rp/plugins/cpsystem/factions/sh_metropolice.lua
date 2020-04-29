--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

FACTION.name = "Metropolice Force"
FACTION.description = "A metropolice unit working as Civil Protection."
FACTION.color = Color(50, 100, 150)
FACTION.pay = 10
FACTION.models = {"models/police.mdl"}
FACTION.weapons = {"ix_stunstick"}
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.runSounds = {[0] = "NPC_MetroPolice.RunFootstepLeft", [1] = "NPC_MetroPolice.RunFootstepRight"}

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()
	local count = 0

	inventory:Add("pistol", 1)
	inventory:Add("pistolammo", 2)

	for _ in pairs(cpSystem.config.taglines) do 
		count = count + 1 
	end

	character:SetData("cpTagline", cpSystem.config.taglines[Schema:ZeroNumber(math.random(1, count), 2)])
	character:SetData("cpID", Schema:ZeroNumber(math.random(1, 9), 1));
	character:SetData("cpRank", "D");
end

function FACTION:GetDefaultName(client)
	local name = ix.config.Get("CP Naming Scheme");

	if(string.find(name, "city")) then
		name = name:gsub("city", ix.config.Get("City Name"))
	end;
	
	if(string.find(name, "abbreviation")) then
		name = name:gsub("city", ix.config.Get("Civil Protection Abbreviation"))
	end;

	if(string.find(name, "rank")) then
		name = name:gsub("rank", client:GetCharacter():GetData("cpRank"));
	end;

	if(string.find(name, "tagline")) then
		name = name:gsub("tagline", client:GetCharacter():GetData("cpTagline"));
	end;

	if(string.find(name, "id")) then
		name = name:gsub("id", client:GetCharacter():GetData("cpID"));
	end;
	
	return name, true
end

function FACTION:OnNameChanged(client, oldValue, value)
	local character = client:GetCharacter();
end

FACTION_MPF = FACTION.index
