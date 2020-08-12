local PLUGIN = PLUGIN;
local proj = {};
proj["prop_combine_ball"]	 = true;
proj["npc_grenade_frag"]	 = true;
proj["rpg_missile"]			 = true;
proj["grenade_ar2"]			 = true;
proj["crossbow_bolt"]		 = true;
proj["npc_combine_camera"]	 = true;
proj["npc_turret_ceiling"]	 = true;
proj["npc_cscanner"]		 = true;
proj["npc_combinedropship"]	 = true;
proj["npc_combine_s"]		 = true;
proj["npc_combinegunship"]	 = true;
proj["npc_hunter"]			 = true;
proj["npc_helicopter"]		 = true;
proj["npc_manhack"]			 = true;
proj["npc_metropolice"]		 = true;
proj["npc_rollermine"]		 = true;
proj["npc_clawscanner"]		 = true;
proj["npc_stalker"]			 = true;
proj["npc_strider"]			 = true;
proj["npc_turret_floor"] 	 = true;
proj["prop_vehicle_zapc"]	 = true;
proj["prop_physics"]		 = true;
proj["hunter_flechette"]	 = true;
proj["npc_tripmine"]		 = true;

function PLUGIN:ShouldCollide(a, b)
	local client;
	local entity;

	if (a:IsPlayer()) then
		client = a;
		entity = b;
	elseif (b:IsPlayer()) then
		client = b;
		entity = a;
	elseif (proj[a:GetClass()] and b:GetClass() == "ix_forcefield") then
		return false;
	elseif (proj[b:GetClass()] and a:GetClass() == "ix_forcefield") then
		return false;
	end;

	if (IsValid(entity) and entity:GetClass() == "ix_forcefield") then
		if (IsValid(client) and client:GetCharacter()) then
			local faction = client:GetCharacter():GetFaction()

			if (client:IsCombine() or faction == FACTION_ADMIN) then
				return false;
			end;

			return self.modes[entity:GetDTInt(0) or 1][1](client);
		else
			return entity:GetDTInt(0) != 4;
		end;
	end;
end;