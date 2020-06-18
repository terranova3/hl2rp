--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN;

-- Called when a player's uniform status has been changed
function PLUGIN:AdjustPlayer(event, lockedName, client)
    local character = client:GetCharacter();
    local cpData = cpSystem.GetCPDataAsTable(character);
    local charPanel = character:GetCharPanel()

    -- If the uniform isn't biolocked, allow the player to access it.
    if(lockedName == nil) then 
        lockedName = cpSystem.GetCPTagline(character);
    end;
    
    if(PLUGIN:IsMetropolice(character)) then 
        if(event == "Unequipped") then
            character:SetData("cpDesc", character:GetDescription())
            character:SetDescription(cpData.cpCitizenDesc);
            character:SetClass(CLASS_MPUH); 
            client:SetSkin(character:GetData("skin"))
            character:SetData( "customclass", "Citizen" );	
        elseif(event == "Equipped") then
            if(cpSystem.GetCPTagline(character) == lockedName) then
                character:SetData("cpCitizenDesc", character:GetDescription())
                character:SetDescription(cpData.cpDesc);
                character:SetClass(CLASS_MPU);
                client:SetSkin(self:GetArmbandSkin(character))
                character:SetData("customclass", "Civil Protection");
                netstream.Start(client, "RecalculateHUDObjectives", PLUGIN.socioStatus)
            else 
                client:Notify(string.format("That uniform is biolocked to %s. You cannot access its mainframe.", lockedName));
            end;
        end;
        PLUGIN:UpdateName(character);
    end;
    
    ix.charPanel.Update(client)
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

function PLUGIN:GetArmbandSkin(character)
    local rank = character:GetData("cpRank")

    -- This is the skin offset for certs
    local offset = 0

    return Schema.ranks.Get(rank).armband + offset
end

-- Called when a characters rank has been changed
function PLUGIN:SetRank(character, text)
    if(PLUGIN:IsMetropolice(character)) then
        if(PLUGIN:RankExists(text)) then
            local rank = Schema.ranks.Get(text);

            character:SetData("cpRank", rank.text);
            character:SetData("cpAccessLevel", rank.access)
        end;

        PLUGIN:UpdateCharacter(character);
    end;
end;

function PLUGIN:GetAccessLevel(character)
    local access = 0
    if(PLUGIN:IsMetropolice(character)) then
        local cpData = cpSystem.GetCPDataAsTable(character);

        if(PLUGIN:RankExists(cpData.cpRank)) then
            access = Schema.ranks.Get(cpData.cpRank).access;
        end;
    end;

    if(character:GetPlayer():IsAdmin()) then 
        access = 1000;
    end

    return access;
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

-- Called when a character has had data changed
function PLUGIN:UpdateCharacter(character)
    local cpData = cpSystem.GetCPDataAsTable(character);

    if(!character:IsUndercover()) then
        character:SetName(cpSystem.GetCPName(character));
        character:GetPlayer():SetSkin(self:GetArmbandSkin(character))
    elseif(character:IsUndercover() and character:GetName() != cpData.cpCitizenName) then
        character:SetName(cpData.cpCitizenName);
    end;
end;