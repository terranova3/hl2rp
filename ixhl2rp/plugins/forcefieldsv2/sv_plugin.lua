function PLUGIN:LoadFieldsTwo()
	local fieldsTwo = Clockwork.kernel:RestoreSchemaData("forcefieldsv2/" .. game.GetMap())

	for k, v in pairs(fieldsTwo) do
		local ent = ents.Create("z_forcefield")

		ent:SetPos(v.fieldPos)
		ent:SetAngles(v.fieldAng)
		ent:SetSkin(v.fieldSkin)
		ent:Spawn()
		ent.AllowedClasses = v.fieldClasses
		ent:SetDTBool(0, v.fieldEnabled)
		ent:SetDTBool(1, v.fieldUnionCard)
		ent.isLoaded = v.fieldLoaded
	end
end

function PLUGIN:SaveFieldsTwo()
	local fieldsTwo = {}

	for k, v in pairs(ents.FindByClass("z_forcefield")) do
		fieldsTwo[#fieldsTwo + 1] = {
			fieldPos = v:GetPos(),
			fieldAng = v:GetAngles(),
			fieldSkin = v:GetSkin(),
			fieldClasses = v.AllowedClasses,
			fieldEnabled = v:GetDTBool(0),
			fieldUnionCard = v:GetDTBool(1),
			fieldLoaded = true
		}
	end

	ix.data.Set("forceFields", data)
end

netstream.Hook("forcefieldRequest", function(client, operation, toAdd)
	if (IsValid(client:GetNWEntity("ffTarget", nil))) then
		local forcefield = client:GetNWEntity("ffTarget", nil);

		if (type(toAdd) == "Client") then
			if (!IsValid(toAdd)) then
				return;
			end;
		end;

		if (operation == "addClass") then
			forcefield:AddClass(toAdd);
		elseif (operation == "removeClass") then
			forcefield:RemoveClass(toAdd);
		end
	end;
end);

netstream.Hook("forcefieldUnionCardRequest", function(client, bUnionCardAccess)
	if (IsValid(client:GetNWEntity("ffTarget", nil))) then
		local forcefield = client:GetNWEntity("ffTarget", nil);

		forcefield:SetDTBool(1, bUnionCardAccess)
	end
end);

netstream.Hook("forcefieldEditorClosed", function(client)
	client:SetNWEntity("ffTarget", nil);
end);
