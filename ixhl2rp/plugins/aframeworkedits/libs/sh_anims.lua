--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local handsModels = {};
local blackModels = {};

-- A function to add viewmodel c_arms info to a model.
function ix.anim:AddHandsModel(model, hands)
	handsModels[string.lower(model)] = hands;
end;

-- A function to make a model use the black skin for hands viewmodels.
function ix.anim:AddBlackModel(model)
	blackModels[string.lower(model)] = true;
end;

-- A function to make a model use the zombie skin for citizen hands.
function ix.anim:AddZombieHands(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/weapons/c_arms_citizen.mdl",
		skin = 2
	});
end;

-- A function to make a model use the HL2 HEV viewmodel hands.
function ix.anim:AddHEVHands(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/weapons/c_arms_hev.mdl",
		skin = 0
	});
end;

-- A function to make a model use the civil protection viewmodel hands.
function ix.anim:AddCivilProtectionHands(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/weapons/c_arms_metrocop_hd.mdl",
		skin = 0
	});
end

-- A function to make a model use the combine viewmodel hands.
function ix.anim:AddCombineHands(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/weapons/c_arms_combine.mdl",
		skin = 0
	});
end;

-- A function to make a model use the CSS viewmodel hands.
function ix.anim:AddCSSHands(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/weapons/c_arms_cstrike.mdl",
		skin = 0
	});
end;

-- A function to make a model use the refugee viewmodel hands.
function ix.anim:AddRefugeeHands(model)
	self:AddHandsModel(model, {
		body = 01,
		model = "models/weapons/c_arms_refugee.mdl",
		skin = 0
	});
end;

-- a function to make a model use the refugee viewmodel hands with a zombie skin.
function ix.anim:AddZombieRefugeeHands(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/weapons/c_arms_refugee.mdl",
		skin = 2
	});
end;

-- A function to check for stored hands info by model.
function ix.anim:CheckHands(model)
	local info = {
		body = 0000000,
		model = "models/weapons/c_arms_citizen.mdl",
		skin = 0
	};

	for k, v in pairs(handsModels) do
		if (string.find(model, k)) then
			info = v;

			break;
		end;
	end;

	self:AdjustHandsInfo(model, info);

	return info;
end;

-- A function to adjust the hands info with checks for if a model is set to use the black skin.
function ix.anim:AdjustHandsInfo(model, info)
	if (info.model == "models/weapons/c_arms_citizen.mdl" or info.model == "models/weapons/c_arms_refugee.mdl") then
		for k, v in pairs(blackModels) do
			if (string.find(model, k)) then
				info.skin = 1;

				break;
			elseif (info.skin == 1) then
				info.skin = 0;
			end;
		end;
	end;
end;

-- A function to get the c_model hands based on model.
function ix.anim:GetHandsInfo(model)
	return self:CheckHands(string.lower(model));
end;

ix.anim:AddBlackModel("/male_01.mdl");
ix.anim:AddBlackModel("/male_03.mdl");
ix.anim:AddBlackModel("/male_13.mdl");
ix.anim:AddBlackModel("/female_03.mdl");

ix.anim:AddRefugeeHands("/group03/");
ix.anim:AddRefugeeHands("/group03m/");

ix.anim:AddZombieRefugeeHands("/Zombie/");