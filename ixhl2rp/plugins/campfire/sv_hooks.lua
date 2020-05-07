--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

-- Called when a player initially spawns.
function PLUGIN:PlayerSpawn(player)
	timer.Simple( 1, function() 
		for k, v in ipairs(ents.FindByClass("ix_campfire")) do
			v:stopFire();
			v:startFire();
		end;
	end);
end;

-- Called when HELIX is loading all the data that has been saved.
function PLUGIN:LoadData()
	for _, v in ipairs(self:GetData() or {}) do
		local entity = ents.Create("ix_campfire")
		entity:SetPos(v.pos)
		entity:SetAngles(v.angles)
		entity:Spawn()
	end
end

-- Called just after data should be saved.
function PLUGIN:SaveData()
	local data = {};
	
	for k, v in pairs( ents.FindByClass("ix_campfire") ) do
		data[#data + 1] = {
			pos = entity:GetPos(),
			angles = entity:GetAngles(),
		};
	end;

	self:SetData(data)
end;
