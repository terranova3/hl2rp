--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN;

-- Called when a player's uniform status has been changed
function PLUGIN:AdjustPlayer(event, lockedName, client)
    local character = client:GetCharacter();
    local cpData = PLUGIN:GetCPDataAsTable(character);

    -- If the uniform isn't biolocked, allow the player to access it.
    if(lockedName == nil) then 
        lockedName = PLUGIN:GetCPTagline(character);
    end;
    
    if(PLUGIN:IsMetropolice(character)) then 
        if(event == "Unequipped") then
            character:SetData("cpDesc", character:GetDescription())
            character:SetDescription(cpData.cpCitizenDesc);
            character:SetClass(CLASS_MPUH);  
            character:SetData( "customclass", "Citizen" );	
        elseif(event == "Equipped") then
            if(PLUGIN:GetCPTagline(character) == lockedName) then
                character:SetData("cpCitizenDesc", character:GetDescription())
                character:SetDescription(cpData.cpDesc);
                character:SetClass(CLASS_MPU);
                character:SetData("customclass", "Civil Protection");
                netstream.Start(client, "RecalculateHUDObjectives", PLUGIN.socioStatus)
            else 
                client:Notify(string.format("That uniform is biolocked to %s. You cannot access its mainframe.", lockedName));
            end;
        end;

        PLUGIN:UpdateName(character);
    end;
end;

function PLUGIN:IsWearingUniform(character)
	for _, v in pairs(character:GetInventory():GetItems()) do
		if(v.base == "base_cp_uniform") then
			if(v:GetData("equip") == true) then 
				return true;
			end;
		end;
	end;

	return false;
end;

-- Called when a characters rank has been changed
function PLUGIN:SetRank(character, text)
    if(PLUGIN:IsMetropolice(character)) then
        if(PLUGIN:RankExists(text)) then
            local rank = Schema.ranks.Get(text);

            character:SetData("cpRank", rank.text);
            character:SetData("cpAccessLevel", rank.access)
        end;

        PLUGIN:UpdateName(character);
    end;
end;

function PLUGIN:GetAccessLevel(character)
    if(PLUGIN:IsMetropolice(character)) then
        local cpData = PLUGIN:GetCPDataAsTable(character);

        if(PLUGIN:RankExists(cpData.cpRank)) then
            return Schema.ranks.Get(cpData.cpRank).access;
        end;
    end;

    return 0;
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
function PLUGIN:GetCPName(character, isScanner)
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

    return string.match(PLUGIN:GetCPName(character), cpData.cpTagline..'.-$');
end;

-- Returns all of the plugin's character data as a single table
function PLUGIN:GetCPDataAsTable(character)
    local data = {}

    if(PLUGIN:IsMetropolice(character)) then 
        data.cpID = character:GetData("cpID");
        data.cpTagline = character:GetData("cpTagline");
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
