local PLUGIN = PLUGIN

ix.command.Add("addforcefield", {
	description = "Adds a forcefield barrier at your cursor.",
    adminOnly = true,
	OnRun = function(player, arguments)
		local trace = player:GetEyeTraceNoCursor();
		if (!trace.Hit) then return end
	
	
		local field = ents.Create("z_forcefield");
		field:SpawnFunction(player, trace)
		field:Remove()
	end;
})