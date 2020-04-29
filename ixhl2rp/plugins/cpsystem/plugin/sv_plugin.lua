--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN;

function PLUGIN:AdjustPlayer(event, client)
    local character = client:GetCharacter();
    local cpData = PLUGIN:GetCPDataAsTable(character);
	
    if(event == "Unequipped") then
		character:SetData("cpDesc", character:GetDescription())
        character:SetDescription(cpData.cpCitizenDesc);
        character:SetName(cpData.cpCitizenName);
        character:SetClass(CLASS_MPUH);  
		character:SetData( "customclass", "Citizen" );				
	elseif(event == "Equipped") then	        
		character:SetData("cpCitizenDesc", character:GetDescription())
        character:SetDescription(cpData.cpDesc);
        character:SetName("test");
        character:SetClass(CLASS_MPU);
		character:SetData("customclass", "Civil Protection");			
	end; 
end;

function PLUGIN:SetRank(client, rank)
    if(client:IsMetropolice()) then
        local rankTable = Schema.ranks.Get(rank);

        if(rankTable) then
            client:GetCharacter():SetData("cpRank", rank.text);
            client:GetCharacter():SetData("cpAccessLevel", rank.access)
        end;
    end;
end;

function PLUGIN:GetAccessLevel(client)
    if(client:IsMetropolice()) then
        return client:GetCharacter():GetData("cpAccessLevel");
    end;
end;

function PLUGIN:GetCPName(character)
    local template = ix.config.Get("CP Naming Scheme");
    
	replacements = {
		["city"] = ix.config.Get("City Name"),
		["abbreviation"] = ix.config.Get("Civil Protection Abbreviation"),
		["rank"] = character:GetData("cpRank"),
		["tagline"] = character:GetData("cpTagline"),
		["id"] = character:GetData("cpID")
    }

    local name = string.gsub(template, "%a+", 
	function(str)
		return replacements[str]
    end)
    
    self.SendDebug(name);
    
    return name;
end;

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

function PLUGIN:GetCPDataAsTable(character)
    if(character:GetFaction() == FACTION_MPF) then 
        data = {}
	    data.cpID = character:GetData("cpID");
	    data.cpRank = character:GetData("cpRank");
	    data.cpDesc = character:GetData("cpDesc");
	    data.cpModel = character:GetData("cpModel");
        data.cpDesc = character:GetData("cpDesc");
        data.cpCitizenName = character:GetData("cpCitizenName");
	    data.cpCitizenDesc = character:GetData("cpCitizenDesc");
		data.faction = character:GetFaction();
		data.name = character:Name();
					
	    return data;
	end;
end;

function PLUGIN:SendDebug(text)
    MsgC(Color(0, 255, 100, 255), "[cpSystem] ".. text .." \n");
end;