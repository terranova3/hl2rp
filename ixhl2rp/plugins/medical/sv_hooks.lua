--[[
    Copyright © 2020 Cloud Sixteen

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    © 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

PLUGIN.HitGroupBonesCache = {
    {"ValveBiped.Bip01_R_UpperArm", HITGROUP_RIGHTARM},
    {"ValveBiped.Bip01_R_Forearm", HITGROUP_RIGHTARM},
    {"ValveBiped.Bip01_L_UpperArm", HITGROUP_LEFTARM},
    {"ValveBiped.Bip01_L_Forearm", HITGROUP_LEFTARM},
    {"ValveBiped.Bip01_R_Thigh", HITGROUP_RIGHTLEG},
    {"ValveBiped.Bip01_R_Calf", HITGROUP_RIGHTLEG},
    {"ValveBiped.Bip01_R_Foot", HITGROUP_RIGHTLEG},
    {"ValveBiped.Bip01_R_Hand", HITGROUP_RIGHTARM},
    {"ValveBiped.Bip01_L_Thigh", HITGROUP_LEFTLEG},
    {"ValveBiped.Bip01_L_Calf", HITGROUP_LEFTLEG},
    {"ValveBiped.Bip01_L_Foot", HITGROUP_LEFTLEG},
    {"ValveBiped.Bip01_L_Hand", HITGROUP_LEFTARM},
    {"ValveBiped.Bip01_Pelvis", HITGROUP_STOMACH},
    {"ValveBiped.Bip01_Spine2", HITGROUP_CHEST},
    {"ValveBiped.Bip01_Spine1", HITGROUP_CHEST},
    {"ValveBiped.Bip01_Head1", HITGROUP_HEAD},
    {"ValveBiped.Bip01_Neck1", HITGROUP_HEAD}
};

local playerMeta = FindMetaTable("Player");

-- A function to get a player's last hit group.
function playerMeta:LastHitGroup()
	return self.LastHitGroup or self:ClockworkLastHitGroup();
end;

-- Called when a player is attacked by a trace.
function PLUGIN:PlayerTraceAttack(client, damageInfo, direction, trace)
	client.LastHitGroup = trace.HitGroup;
	return false;
end;

-- Called when an entity takes damage.
function PLUGIN:EntityTakeDamage(entity, damageInfo)
	local inflictor = damageInfo:GetInflictor();
	local attacker = damageInfo:GetAttacker();
	local amount = damageInfo:GetDamage();
	
	if (damageInfo:GetDamage() == 0) then
		return;
	end;
	
	local client = entity.ixPlayer;
	
    if (client and (entity:IsPlayer() or IsValid(client.ixRagdoll))) then
		if (!IsValid(client.ixRagdoll)) then
            local lastHitGroup = client:LastHitGroup();
            
            self:ScaleDamageByHitGroup(client, attacker, lastHitGroup, damageInfo, amount);
            
            if (damageInfo:GetDamage() > 0) then
                self:CalculatePlayerDamage(client, lastHitGroup, damageInfo);
            end;
		else
			local hitGroup = self:GetRagdollHitGroup(entity, damageInfo:GetDamagePosition());
			local curTime = CurTime();
			local killed = nil;
			
			self:ScaleDamageByHitGroup(client, attacker, hitGroup, damageInfo, amount);
			
			if (damageInfo:GetDamage() > 0) then
				if (!attacker:IsPlayer()) then
					if (attacker:GetClass() == "prop_ragdoll" or damageInfo:GetDamage() < 5) then
						return;
					end;
				end;
				
				if (damageInfo:GetDamage() >= 10 or damageInfo:IsBulletDamage()) then
					--PLUGIN:CreateBloodEffects(damageInfo:GetDamagePosition(), 1, entity, damageInfo:GetDamageForce());
				end;
				
                self:CalculatePlayerDamage(client, hitGroup, damageInfo);
            end;
		end;
	end;
end;

-- A function to scale damage by hit group.
function PLUGIN:ScaleDamageByHitGroup(client, attacker, hitGroup, damageInfo, baseDamage)
    if (!damageInfo:IsFallDamage() and !damageInfo:IsDamageType(DMG_CRUSH)) then
        if (hitGroup == HITGROUP_HEAD) then
            damageInfo:ScaleDamage(1.5);
        elseif (hitGroup == HITGROUP_CHEST or hitGroup == HITGROUP_GENERIC) then
            damageInfo:ScaleDamage(1);
        elseif (hitGroup == HITGROUP_LEFTARM or hitGroup == HITGROUP_RIGHTARM or hitGroup == HITGROUP_LEFTLEG
        or hitGroup == HITGROUP_RIGHTLEG or hitGroup == HITGROUP_GEAR) then
            damageInfo:ScaleDamage(0.75);
        end;
    end;
end;
    
-- A function to calculate player damage.
function PLUGIN:CalculatePlayerDamage(client, hitGroup, damageInfo)
    local bDamageIsValid = damageInfo:IsBulletDamage() or damageInfo:IsDamageType(DMG_CLUB) or damageInfo:IsDamageType(DMG_SLASH);
    local character = client:GetCharacter()
  
    if (client:Armor() > 0 and bDamageIsValid and bHitGroupIsValid) then
        local armor = client:Armor() - damageInfo:GetDamage();
        
        if (armor < 0) then
            ix.limb:TakeDamage(character, hitGroup, damageInfo:GetDamage() * 2);
            client:SetHealth(mathMax(client:Health() - mathAbs(armor), 1));
            client:SetArmor(mathMax(armor, 0));
        else
            client:SetArmor(mathMax(armor, 0));
        end;
    else
        ix.limb:TakeDamage(character, hitGroup, damageInfo:GetDamage() * 2);
        client:SetHealth(mathMax(client:Health() - damageInfo:GetDamage(), 1));
    end;
    
    if (damageInfo:IsFallDamage()) then
        ix.limb:TakeDamage(character, HITGROUP_RIGHTLEG, damageInfo:GetDamage());
        ix.limb:TakeDamage(character, HITGROUP_LEFTLEG, damageInfo:GetDamage());
    end;
end;

function PLUGIN:GetRagdollHitGroup(entity, position)
    local closest = {nil, HITGROUP_GENERIC};
    
    for k, v in pairs(self.HitGroupBonesCache) do
        local bone = entity:LookupBone(v[1]);
        
        if (bone) then
            local bonePosition = entity:GetBonePosition(bone);
            
            if (position) then
                local distance = bonePosition:Distance(position);
                
                if (!closest[1] or distance < closest[1]) then
                    closest[1] = distance;
                    closest[2] = v[2];
                end;
            end;
        end;
    end;
    
    return closest[2];
end;
