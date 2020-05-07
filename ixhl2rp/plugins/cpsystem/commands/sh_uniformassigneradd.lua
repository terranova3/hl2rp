--[[
	© 2020 Terra Nova do not use, share, re-distribute or modify without 
	permission of its author.
--]]

local PLUGIN = PLUGIN

ix.command.Add("UniformAssignerAdd", {
	adminOnly = true,
    OnRun = function(self, client)
		local trace = client:GetEyeTraceNoCursor();
		local data = {
			position = trace.HitPos + Vector(0, 0, 0),
		};
		
		data.angles = client:EyeAngles();
		data.angles.pitch = 0;
		data.angles.roll = 0;
		data.angles.yaw = data.angles.yaw + 180;
		
		data.entity = ents.Create("ix_uniformgen");
		data.entity:SetAngles(data.angles);
		data.entity:SetPos(data.position);
		data.entity:Spawn();
		
		data.entity:GetPhysicsObject():EnableMotion(false);

        client:Notify("You have spawned a uniform assigner.");
	end;
})