--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN;

-- Called when a player's uniform status has been changed
function PLUGIN:AdjustPlayer(event, client)
    local character = client:GetCharacter();
    local cpData = character:GetCPInfo()
  
    if(character:IsMetropolice()) then 
        if(event == "Unequipped") then
            character:SetDescription(cpData.cpCitizenDesc);
            character:SetClass(CLASS_MPUH); 
            character:SetCustomClass("Citizen" );	
        elseif(event == "Equipped") then
            character:SetDescription(cpData.cpDesc);
            character:SetClass(CLASS_MPU);
            character:SetCustomClass("Civil Protection");
            netstream.Start(client, "RecalculateHUDObjectives", PLUGIN.socioStatus)
        end;
        
        client:ResetBodygroups()
        character:UpdateCPStatus();
    end;
end;

-- Returns if a tagline exists from the tagline config table.
function PLUGIN:TaglineExists(tagline)
    for i = 1, #cpSystem.config.taglines do
        if(tagline == cpSystem.config.taglines[i]) then
            return true;
        end;
    end;

    return false;
end;