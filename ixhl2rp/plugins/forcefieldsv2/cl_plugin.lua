timer.Create("forcefieldUpdater", 250, 0, function()
	for k, v in pairs(ents.FindByClass("z_forcefield")) do
		if (IsValid(v:GetDTEntity(0))) then
			local startPos = v:GetDTEntity(0):GetPos() - Vector(0, 0, 50);
			local verts = {
				{pos = Vector(0, 0, -35)},
				{pos = Vector(0, 0, 150)},
				{pos = v:WorldToLocal(startPos) + Vector(0, 0, 150)},
				{pos = v:WorldToLocal(startPos) + Vector(0, 0, 150)},
				{pos = v:WorldToLocal(startPos) - Vector(0, 0, 35)},
				{pos = Vector(0, 0, -35)},
			};

			v:PhysicsFromMesh(verts);
			v:EnableCustomCollisions(true);
			v:GetPhysicsObject():EnableCollisions(false)
		end;
	end;
end);

netstream.Hook("forcefieldMenu", function(forcefield)
	if (FFMenu) then
		FFMenu:Remove();
		FFMenu = nil;
	end;

	FFMenu = vgui.Create("forcefieldMenu");
	FFMenu:Center();
	FFMenu.forcefield = forcefield;
end);

netstream.Hook("forcefieldUpdate", function(operation, data)
	local forcefield = data[1];

	if (operation == "fullUpdate") then
		forcefield.AllowedClasses = data[2];
	elseif (operation == "addClass") then
		forcefield.AllowedClasses = forcefield.AllowedClasses or {};

		forcefield.AllowedClasses[data[2]] = true;
	elseif (operation == "removeClass") then
		forcefield.AllowedClasses = forcefield.AllowedClasses or {};

		forcefield.AllowedClasses[data[2]] = nil;
	end;
end);