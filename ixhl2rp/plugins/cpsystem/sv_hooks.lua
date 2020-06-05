--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local Schema = Schema;
local PLUGIN = PLUGIN;

-- Called when the plugin is initialized.
-- In a large database this can be expensive, don't reload cache on lua autorefresh.
function PLUGIN:InitializedPlugins()
	if(cpSystem.cache == nil) then
		cpSystem.cache = {}
		cpSystem.cache.taglines = {}

		local query = mysql:Select("ix_characters")
		query:Select("faction")
		query:Select("data")
		query:WhereLike("faction", "metropolice")
		query:Callback(function(result)
			if (istable(result) and #result > 0) then
				for k, v in pairs(result) do 
					local data = util.JSONToTable(v.data or "[]")

					if(data.cpTagline and data.cpID) then
						table.insert(cpSystem.cache.taglines, {
							tagline = data.cpTagline, 
							id = tonumber(data.cpID)
						})
					end
				end 
			end
		end)
		query:Execute()
	end
end

function PLUGIN:LoadData()
	for _, v in ipairs(self:GetData() or {}) do
		local entity = ents.Create("ix_uniformgen")
		entity:SetPos(v.pos)
		entity:SetAngles(v.angles)
		entity:Spawn()

		entity:SetModel(v.model)
		entity:SetSkin(v.skin or 0)
		entity:SetSolid(SOLID_BBOX)
		entity:PhysicsInit(SOLID_BBOX)

		local physObj = entity:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end
	end
end

function PLUGIN:SaveData()
	local data = {}

	for _, entity in ipairs(ents.FindByClass("ix_uniformgen")) do
		data[#data + 1] = {
			pos = entity:GetPos(),
			angles = entity:GetAngles(),
			model = entity:GetModel(),
		}
	end

	self:SetData(data)
end

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
	
	if(faction == FACTION_SCN) then
		character:SetClass(CLASS_SCN);
	end;

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

-- Called just after a player spawns.
function PLUGIN:PlayerSpawn(client)
	if (client:IsCombine()) then
		netstream.Start(client, "RecalculateHUDObjectives", PLUGIN.socioStatus)
	end;
end;

function PLUGIN:CanPlayerEquipItem(client, item)
	local charPanel = client:GetCharacter():GetCharPanel();

	if(item.base == "base_cp_uniform") then
		if(charPanel:HasEquipped()) then
			client:Notify("You can't equip a uniform with items in your character panel!")
			return false;
		end
	end;

	return true;
end

-- Called when the client is checking if it has access to see the character panel
function PLUGIN:CharPanelShouldShow(client)
	print(client)
	if (client:IsCombine()) then
		return false
	end
end;

netstream.Hook("ViewDataUpdate", function(client, target, text, combinePoints)
	if (IsValid(target) and client:GetCharacter() and target:GetCharacter()) then
		local data = {
			text = text,
			editor = client:GetCharacter():GetName(),
			points = combinePoints
		}

		target:GetCharacter():SetData("combineData", data)
		Schema:AddCombineDisplayMessage("@cViewDataFiller", nil, client)
	end
end)

netstream.Hook("RequestTaglineCache", function(client)
	netstream.Start(client, "ReceiveTaglineCache", cpSystem.cache.taglines)
end)