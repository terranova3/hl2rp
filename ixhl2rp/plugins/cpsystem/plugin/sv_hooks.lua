--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local Schema = Schema;
local PLUGIN = PLUGIN;

function Schema:PlayerFootstep(client, position, foot, soundName, volume)
	local factionTable = ix.faction.Get(client:Team());
	local character = client:GetCharacter();

	if(character:IsUndercover()) then
		client:EmitSound(soundName);
		return true;
	end;

	if (factionTable.runSounds and client:IsRunning()) then
		client:EmitSound(factionTable.runSounds[foot]);
		return true;
	end

	client:EmitSound(soundName);
	return true;
end

function PLUGIN:PlayerLoadedCharacter(client, character, oldCharacter)
	local faction = character:GetFaction()
	
	-- Updates player name if the city has been changed. --
	if(faction == FACTION_MPF) then
		if(character:GetName() == PLUGIN:GetCPName(character)) then
			if(!string.find(character:GetName(), ix.config.Get("City Name"))) then 
				character:SetName(PLUGIN:GetCPName(character));
			end;
		end;
	end;

	-- Adds player to the correct class --
	if(faction == FACTION_MPF) then
		if (!string.find(character:GetName(), ix.config.Get("City Name"))) then
			character:SetClass(CLASS_MPUH);  
		else
			character:SetClass(CLASS_MPU); 		
		end;
	end;
end;