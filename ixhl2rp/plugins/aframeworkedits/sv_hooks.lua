--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

-- Called when a player's model has changed.
function PLUGIN:PlayerModelChanged(client, model)
	local hands = client:GetHands();

    if (IsValid(hands) and hands:IsValid()) then
		self:PlayerSetHandsModel(client, client:GetHands(), model);
	end;
end;

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
