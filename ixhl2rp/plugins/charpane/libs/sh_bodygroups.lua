--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

PLUGIN.slots = {
	["citizen"] = {
		["torso"] = 1,
		["legs"] = 2,
		["hands"] = 3,
		["headgear"] = 4,
		["bag"] = 5,
		["glasses"] = 6,
		["satchel"] = 7,
		["pouch"] = 8,
		["badge"] = 9,
		["headstrap"] = 10,
		["kevlar"] = 11
	},
	["mpf"] = {
		["gasmask"] = 1,
		["coat"] = 2
	}
}

function PLUGIN:GetAvaliableBodygroups(model)
	if(string.find(model, "models/newcca/cca_unit.mdl")) then
		return self.slots["mpf"];
	elseif(string.find(model, "new/citizens/")) then
		return self.slots["citizen"];
	end;

	return nil;
end;

function PLUGIN:ResetBodygroups(character)
	character:SetData("bodygroups", nil);
end;

function PLUGIN:SetBodygroup(character, slot, value)
	local bodygroupsAvaliable = self:GetAvaliableBodygroups(character:GetModel());
	local bodygroups = character:GetData("bodygroups") or {};

	for k, v in pairs(bodygroupsAvaliable) do
		if(bodygroupsAvaliable[k] == slot) then
			bodygroups[k] = value;
		end;
	end;
end;

function PLUGIN:ApplyBodygroups(character)
	local bodygroupsAvaliable = self:GetAvaliableBodygroups(character:GetModel());
	local bodygroups = character:GetData("bodygroups") or {};

	for k, v in pairs(bodygroups) do
		local index = bodygroupsAvaliable[k];

		character:GetPlayer():SetBodygroup(index, bodygroups[v])
	end;
end;