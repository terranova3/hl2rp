--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN;

-- Called when a player's uniform status has been changed
function PLUGIN:AdjustPlayer(event, client)
    local character = client:GetCharacter();
    local cpData = PLUGIN:GetCPDataAsTable(character);
    
    if(PLUGIN:IsMetropolice(character)) then 
        if(event == "Unequipped") then
            character:SetData("cpDesc", character:GetDescription())
            character:SetDescription(cpData.cpCitizenDesc);
            character:SetClass(CLASS_MPUH);  
            character:SetData( "customclass", "Citizen" );	
        elseif(event == "Equipped") then	        
            character:SetData("cpCitizenDesc", character:GetDescription())
            character:SetDescription(cpData.cpDesc);
            character:SetClass(CLASS_MPU);
            character:SetData("customclass", "Civil Protection");			
        end;

        PLUGIN:UpdateName(character);
    end;
end;

-- Called when a characters rank has been changed
function PLUGIN:SetRank(character, rank)
    if(PLUGIN:IsMetropolice(character)) then
        if(PLUGIN:RankExists(rank)) then
            character:SetData("cpRank", rank.text);
            character:SetData("cpAccessLevel", rank.access)
        end;

        PLUGIN:UpdateName(character);
    end;
end;

-- Returns if rank exists from the rank table.
function PLUGIN:RankExists(rank)
    local rankTable = Schema.ranks.Get(rank);

    if(rankTable) then
        return true;
    else
        return false;
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

-- Called when a character has had data changed that requires their name to be updated
function PLUGIN:UpdateName(character)
    local cpData = PLUGIN:GetCPDataAsTable(character);

    if(!character:IsUndercover()) then
        character:SetName(PLUGIN:GetCPName(character));
    elseif(character:IsUndercover() and character:GetName() != cpData.cpCitizenName) then
        character:SetName(cpData.cpCitizenName);
    end;
end;

-- Returns full civil protection name as a single string
function PLUGIN:GetCPName(character)
    local template = ix.config.Get("Naming Scheme");
    
	replacements = {
		["city"] = ix.config.Get("City Name"),
        ["abbreviation"] = ix.config.Get("Abbreviation"),
        ["division"] = character:GetData("cpDivision"),
		["rank"] = character:GetData("cpRank"),
		["tagline"] = character:GetData("cpTagline"),
		["id"] = character:GetData("cpID")
    }

    local name = string.gsub(template, "%a+", 
	function(str)
		return replacements[str];
    end)
    
    return name;
end;

-- Returns tagline and id together as a single string
-- TODO: If name template isn't tagline and ID together then this will be incorrect.
function PLUGIN:GetCPTagline(character)
    local cpData = PLUGIN:GetCPDataAsTable(character);

    return string.match(cpData.tagline, cpData.tagline..'.-$');
end;

-- Returns all of the plugin's character data as a single table
function PLUGIN:GetCPDataAsTable(character)
    local data = {}

    if(PLUGIN:IsMetropolice(character)) then 
	    data.cpID = character:GetData("cpID");
        data.cpRank = character:GetData("cpRank");
        data.cpAccessLevel = character:GetData("cpAccessLevel");	
	    data.cpDesc = character:GetData("cpDesc");
	    data.cpModel = character:GetData("cpModel");
        data.cpDesc = character:GetData("cpDesc");
        data.cpCitizenName = character:GetData("cpCitizenName");
	    data.cpCitizenDesc = character:GetData("cpCitizenDesc");					
    end;
    
    return data;
end;

-- Returns if a character is a part of the MPF faction.
function PLUGIN:IsMetropolice(character)
    if(character:GetFaction() == FACTION_MPF) then
        return true;
    else
        return false;
    end;
end;
