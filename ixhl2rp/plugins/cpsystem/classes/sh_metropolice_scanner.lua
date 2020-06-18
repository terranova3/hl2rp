CLASS.name = "Metropolice Scanner"
CLASS.description = "A metropolice scanner, it utilises Combine technology."
CLASS.faction = FACTION_SCN
CLASS.isDefault = true;
CLASS.color = Color(50, 100, 150)

function CLASS:OnSpawn(client)
	if (IsValid(client.ixScanner) and !client.ixScanner.bPendingRemove) then
		client.ixScanner.position = client:GetPos()
		client.ixScanner.bPendingRemove = true
		client.ixScanner:Remove()
	else
		Schema:CreateScanner(client)
	end
end

function CLASS:OnLeave(client)
	if (IsValid(client.ixScanner)) then
		local data = {}
			data.start = client.ixScanner:GetPos()
			data.endpos = data.start - Vector(0, 0, 1024)
			data.filter = {client, client.ixScanner}
		local position = util.TraceLine(data).HitPos

		client.ixScanner.position = position
		client.ixScanner:Remove()
	end
end

CLASS_SCN = CLASS.index
