--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

CAMI.RegisterPrivilege({
	Name = "Helix - Spawn Containers",
	MinAccess = "admin"
})

util.AddNetworkString("ixStartSound")

-- Called when a player's model has changed.
function PLUGIN:PlayerModelChanged(client, model)
	local hands = client:GetHands();

    if (IsValid(hands) and hands:IsValid()) then
		self:PlayerSetHandsModel(client, client:GetHands(), model);
	end;
end;

-- Implements the animation for picking up items.
function PLUGIN:InventoryItemAdded(oldInv, inventory, item)
	local client = inventory:GetOwner()

	if(oldInv and oldInv:GetID() == 0 and !client:InObserver() and client.ixUntimedSequence == nil) then
		local entity = item.entity

		if(IsValid(client) and IsValid(entity)) then
			local entityPosition = entity:GetPos();
			local shootPosition = client:GetShootPos();
			local feetDistance = client:GetPos():Distance(entityPosition);
			local armsDistance = shootPosition:Distance(entityPosition);

			if (feetDistance < armsDistance) then
				client:ForceSequence("pickup", nil, 1.2, true)
			else
				client:ForceSequence("gunrack", nil, 1.2, true)
			end;
		end
	end
end

-- This function is used to set the c_hands of a character's model.
function PLUGIN:PlayerSetHandsModel(client, entity, model)
	if(!model) then
		model = client:GetModel()
	end

    local simpleModel = player_manager.TranslateToPlayerModelName(model)
	local info = ix.anim:GetHandsInfo(model) or player_manager.TranslatePlayerHands(simpleModel);

    if (info) then
		entity:SetModel(info.model);
		entity:SetSkin(info.skin);

		local bodyGroups = tostring(info.body);

		if (bodyGroups) then
			bodyGroups = string.Explode("", bodyGroups);

			for k, v in pairs(bodyGroups) do
				local num = tonumber(v);

				if (num) then
					entity:SetBodygroup(k, num);
				end;
			end;
		end;
	end;
end;

-- Used to set the relationship of an entity based on the data in the faction tables.
function PLUGIN:OnEntityCreated(entity)
	if (IsValid(entity) and entity:IsNPC()) then
		local class = entity:GetClass()

		-- fake class for rebel turrets
		if (class == "npc_turret_floor") then
			if (!entity.m_bInitialized) then
				timer.Simple(0, function()
					self:OnEntityCreated(entity)
				end)

				entity.m_bInitialized = true
				return
			elseif (entity.bCitizenModified) then
				class = "npc_turret_floor_rebel"
			end
		end

		for _, client in ipairs(player.GetAll()) do
			local character = client:GetCharacter()

			if (character) then
				local faction = ix.faction.indices[client:Team()]
				local relations = faction.npcRelations

				entity:AddEntityRelationship(client, istable(relations) and relations[class] or D_HT, 0)
			end
		end
	end
end

-- Sets the relationship between entities once a new player spawns.
function PLUGIN:PlayerSpawn(client)
	local character = client:GetCharacter()

	if (character) then
		local faction = ix.faction.indices[character:GetFaction()]
		local relations = faction.npcRelations

		for _, v in ipairs(ents.FindByClass("npc_*")) do
			if (v:IsNPC()) then
				local class = v:GetClass()

				-- fake class for rebel turrets
				if (class == "npc_turret_floor" and v.bCitizenModified) then
					class = "npc_turret_floor_rebel"
				end

				v:AddEntityRelationship(client, istable(relations) and relations[class] or D_HT, 0)
			end
		end
	end
end

-- Restricts container spawning access to players with the CAMI permission.
function PLUGIN:CanPlayerSpawnContainer(client, model, entity)
	if(CAMI.PlayerHasAccess(client, "Helix - Spawn Containers", nil)) then
		return true
	end
 end