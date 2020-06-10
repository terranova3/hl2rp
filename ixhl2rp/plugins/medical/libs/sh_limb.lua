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

ix.limb = {}
ix.limb.bones = {
	["ValveBiped.Bip01_R_UpperArm"] = HITGROUP_RIGHTARM,
	["ValveBiped.Bip01_R_Forearm"] = HITGROUP_RIGHTARM,
	["ValveBiped.Bip01_L_UpperArm"] = HITGROUP_LEFTARM,
	["ValveBiped.Bip01_L_Forearm"] = HITGROUP_LEFTARM,
	["ValveBiped.Bip01_R_Thigh"] = HITGROUP_RIGHTLEG,
	["ValveBiped.Bip01_R_Calf"] = HITGROUP_RIGHTLEG,
	["ValveBiped.Bip01_R_Foot"] = HITGROUP_RIGHTLEG,
	["ValveBiped.Bip01_R_Hand"] = HITGROUP_RIGHTARM,
	["ValveBiped.Bip01_L_Thigh"] = HITGROUP_LEFTLEG,
	["ValveBiped.Bip01_L_Calf"] = HITGROUP_LEFTLEG,
	["ValveBiped.Bip01_L_Foot"] = HITGROUP_LEFTLEG,
	["ValveBiped.Bip01_L_Hand"] = HITGROUP_LEFTARM,
	["ValveBiped.Bip01_Pelvis"] = HITGROUP_STOMACH,
	["ValveBiped.Bip01_Spine2"] = HITGROUP_CHEST,
	["ValveBiped.Bip01_Spine1"] = HITGROUP_CHEST,
	["ValveBiped.Bip01_Head1"] = HITGROUP_HEAD,
	["ValveBiped.Bip01_Neck1"] = HITGROUP_HEAD
};

-- A function to convert a bone to a hit group.
function ix.limb:BoneToHitGroup(bone)
	return self.bones[bone] or HITGROUP_CHEST;
end;

if (SERVER) then
	function ix.limb:TakeDamage(character, hitGroup, damage)
        local newDamage = math.ceil(damage);
		local limbData = character:GetData("LimbData");
		
		if (limbData) then
			limbData[hitGroup] = math.min((limbData[hitGroup] or 0) + newDamage, 100);
			
			netstream.Start(character:GetPlayer(), "TakeLimbDamage", {
				hitGroup = hitGroup, damage = newDamage
			});
			
			hook.Run("PlayerLimbTakeDamage", character:GetPlayer(), hitGroup, newDamage);
		end;
	end;
	
	-- A function to heal a player's body.
    function ix.limb:HealBody(character, amount)
		local limbData = character:GetData("LimbData");
		
		if (limbData) then
			for k, v in pairs(limbData) do
				self:HealDamage(client, k, amount);
			end;
		end;
	end;
	
	-- A function to heal a player's limb damage.
	function ix.limb:HealDamage(character, hitGroup, amount)
		local newAmount = math.ceil(amount);
		local limbData = character:GetData("LimbData");
		
		if (limbData and limbData[hitGroup]) then
			limbData[hitGroup] = math.max(limbData[hitGroup] - newAmount, 0);
			
			if (limbData[hitGroup] == 0) then
				limbData[hitGroup] = nil;
			end;
			
			netstream.Start(character:GetPlayer(), "HealLimbDamage", {
				hitGroup = hitGroup, amount = newAmount
			});
			
			hook.Run("PlayerLimbDamageHealed", character:GetPlayer(), hitGroup, newAmount);
		end;
	end;
	
	-- A function to reset a player's limb damage.
	function ix.limb:ResetDamage(character)
		character:SetData("LimbData", {});
		
		netstream.Start(character:GetPlayer(), "ResetLimbDamage", true);
		hook.Run("PlayerLimbDamageReset", character:GetPlayer());
	end;
	
	-- A function to get whether any of a player's limbs are damaged.
	function ix.limb:IsAnyDamaged(player)
		local limbData = character:GetData("LimbData");
		
		if (limbData and table.Count(limbData) > 0) then
			return true;
		else
			return false;
		end;
	end
	
	-- A function to get a player's limb health.
	function ix.limb:GetHealth(character, hitGroup, asFraction)
		return 100 - self:GetDamage(character, hitGroup, asFraction);
	end;
	
	-- A function to get a player's limb damage.
	function ix.limb:GetDamage(character, hitGroup, asFraction)		
		local limbData = character:GetData("LimbData");
		
		if (type(limbData) == "table") then
			if (limbData and limbData[hitGroup]) then
				if (asFraction) then
					return limbData[hitGroup] / 100;
				else
					return limbData[hitGroup];
				end;
			end;
		end;
		
		return 0;
	end;
else
	ix.limb.bodyTexture = Material("terranova/ui/medical/body.png");
	ix.limb.stored = ix.limb.stored or {};
	ix.limb.hitGroups = {
		[HITGROUP_RIGHTARM] = Material("terranova/ui/medical/rarm.png"),
		[HITGROUP_RIGHTLEG] = Material("terranova/ui/medical/rleg.png"),
		[HITGROUP_LEFTARM] = Material("terranova/ui/medical/larm.png"),
		[HITGROUP_LEFTLEG] = Material("terranova/ui/medical/lleg.png"),
		[HITGROUP_STOMACH] = Material("terranova/ui/medical/stomach.png"),
		[HITGROUP_CHEST] = Material("terranova/ui/medical/chest.png"),
		[HITGROUP_HEAD] = Material("terranova/ui/medical/head.png")
	};
	ix.limb.names = {
		[HITGROUP_RIGHTARM] = "Right Arm",
		[HITGROUP_RIGHTLEG] = "Right Leg",
		[HITGROUP_LEFTARM] = "Left Arm",
		[HITGROUP_LEFTLEG] = "Left Leg",
		[HITGROUP_STOMACH] = "Stomach",
		[HITGROUP_CHEST] = "Chest",
		[HITGROUP_HEAD] = "Head"
	};
	
	-- A function to get a limb's texture.
	function ix.limb:GetTexture(hitGroup)
		if (hitGroup == "body") then
			return self.bodyTexture;
		else
			return self.hitGroups[hitGroup];
		end;
	end;
	
	-- A function to get a limb's name.
	function ix.limb:GetName(hitGroup)
		return self.names[hitGroup] or "Generic";
	end;
	
	-- A function to get a limb color.
	function ix.limb:GetColor(health)
		if (health > 75) then
			return Color(166, 243, 76, 255);
		elseif (health > 50) then
			return Color(233, 225, 94, 255);
		elseif (health > 25) then
			return Color(233, 173, 94, 255);
		else
			return Color(222, 57, 57, 255);
		end;
	end;
	
	-- A function to get the local player's limb health.
	function ix.limb:GetHealth(hitGroup, asFraction)
		return 100 - self:GetDamage(hitGroup, asFraction);
	end;
	
	-- A function to get the local player's limb damage.
	function ix.limb:GetDamage(hitGroup, asFraction)	
		if (type(self.stored) == "table") then
			if (self.stored[hitGroup]) then
				if (asFraction) then
					return self.stored[hitGroup] / 100;
				else
					return self.stored[hitGroup];
				end;
			end;
		end;
		
		return 0;
	end;
	
	-- A function to get whether any of the local player's limbs are damaged.
	function ix.limb:IsAnyDamaged()
		return table.Count(self.stored) > 0;
    end;

	netstream.Hook("ReceiveLimbDamage", function(data)
		ix.limb.stored = data;
		hook.Run("PlayerLimbDamageReceived");
	end);

	netstream.Hook("ResetLimbDamage", function(data)
		ix.limb.stored = {};
		hook.Run("PlayerLimbDamageReset");
	end);
	
	netstream.Hook("TakeLimbDamage", function(data)
		local hitGroup = data.hitGroup;
		local damage = data.damage;
		
		ix.limb.stored[hitGroup] = math.min((ix.limb.stored[hitGroup] or 0) + damage, 100);
		hook.Run("PlayerLimbTakeDamage", hitGroup, damage);
	end);
	
	netstream.Hook("HealLimbDamage", function(data)
		local hitGroup = data.hitGroup;
		local amount = data.amount;
		
		if (ix.limb.stored[hitGroup]) then
			ix.limb.stored[hitGroup] = math.max(ix.limb.stored[hitGroup] - amount, 0);
			
			if (ix.limb.stored[hitGroup] == 100) then
				ix.limb.stored[hitGroup] = nil;
			end;
			
			hook.Run("PlayerLimbDamageHealed", hitGroup, amount);
		end;
	end);
end;