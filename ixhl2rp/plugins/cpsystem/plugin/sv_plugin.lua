--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN;

-- Called when a player's uniform status has been changed
function PLUGIN:AdjustPlayer(event, client)
    local character = client:GetCharacter();
    local cpData = PLUGIN:GetCPDataAsTable(character);
	
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

-- Called when a characters rank has been changed
function PLUGIN:SetRank(client, rank)
    local character = client:GetCharacter();

    if(client:IsMetropolice()) then
        local rankTable = Schema.ranks.Get(rank);

        if(rankTable) then
            character:SetData("cpRank", rank.text);
            character:SetData("cpAccessLevel", rank.access)
        end;

        PLUGIN:UpdateName(character);
    end;
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
-- TODO: doesn't follow naming scheme
function PLUGIN:GetCPTag(character)
    local cpData = plugin:GetCPDataAsTable(character);

    return cpData.cpTagline .. cpData.cpID;
end;

-- Returns if a rank exists in the stored table
function PLUGIN:DoesRankExist(rank)
    local i = 0;

    for k, v in pairs(Schema.ranks.stored) do 
        if(Schema.ranks.stored[i] == rank) then
            return true;
        end;

		i=i+1;
    end
    
    return false;
end;

-- Returns if a tagline exists in the config tagline table
function PLUGIN:DoesTaglineExist(tagline)
    local i = 0;

    for k, v in pairs(cpSystem.config.taglines) do
        if(cpSystem.config.taglines[i] == tagline) then
            return true;
        end;

        i=i+1;
    end;

    return false;
end;

-- Returns all of the plugin's character data as a single table
function PLUGIN:GetCPDataAsTable(character)
    local data = {}

    if(character:GetFaction() == FACTION_MPF) then 
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

-- Creates a debug message for server
function PLUGIN:SendDebug(text)
    MsgC(Color(0, 255, 100, 255), "[cpSystem] ".. text .." \n");
end;
