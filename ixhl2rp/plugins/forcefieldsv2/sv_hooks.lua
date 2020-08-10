function PLUGIN:KeyPress(client, key)
	local data = {};
	data.start = client:GetShootPos();
	data.endpos = data.start + client:GetAimVector() * 84;
	data.filter = client;
	local trace = util.TraceLine(data);
	local entity = trace.Entity;

	if (key == IN_USE and IsValid(entity) and entity:GetClass() == "z_forcefield") then
		entity:Use(client, client, USE_ON, 1);
	end;
end

function PLUGIN:PlayerInitialSpawn(client)
	if (IsValid(client)) then
		local forcefields = ents.FindByClass("z_forcefield");

		if (!forcefields) then return; end;

		local ffCount = table.Count(forcefields);
		local uid = client:Nick();

		timer.Create("forcefield_Queue" .. uid, 1.5, ffCount, function()
			if (!IsValid(client)) then
				timer.Remove("forcefield_Queue" .. uid);

				return;
			end;

			if (IsValid(forcefields[1])) then
				forcefields[1]:SendFullUpdate(player);
				table.remove(forcefields, 1);
			else
				table.remove(forcefields, 1);
			end;
		end);
	end;
end

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:PostEntity()
	PLUGIN:LoadFieldsTwo();
end;

-- Called just after data should be saved.
function PLUGIN:PostSaveData()
	PLUGIN:SaveFieldsTwo();
end;