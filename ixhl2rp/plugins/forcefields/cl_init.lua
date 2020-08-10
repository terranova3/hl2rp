-- If a client lags out too much, clientside meshes will be removed.
-- This timer will reinstantiate the forcefield meshes every 250 seconds to ensure collisions stay consistent.
timer.Create("forcefieldUpdater", 250, 0, function()
	for k, v in pairs(ents.FindByClass("ix_forcefield")) do
		local data = {};
		data.start = v:GetPos() + Vector(0,0,50) + v:GetRight()*-16;
		data.endpos = v:GetPos() + Vector(0,0,50) + v:GetRight()*-600;
		data.filter = function(ent) if ent == v or ent:GetModel():find("fence") then return false; end; end;
		local trace = util.TraceLine(data);
		local verts = {
			{pos = Vector(0, 0, -39)},
			{pos = Vector(0, 0, 150)},
			{pos = v:WorldToLocal(trace.HitPos - Vector(0,0,50)) + Vector(0, 0, 150)},
			{pos = v:WorldToLocal(trace.HitPos - Vector(0,0,50)) + Vector(0, 0, 150)},
			{pos = v:WorldToLocal(trace.HitPos - Vector(0,0,50)) - Vector(0, 0, 39)},
			{pos = Vector(0, 0, -25)},
		};

		v:PhysicsFromMesh(verts);
		v:EnableCustomCollisions(true);
	end;
end);