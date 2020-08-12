local PLUGIN = PLUGIN;

function PLUGIN:SaveData()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_forcefield")) do
		data[#data + 1] = {
			pos = v:GetPos(), 
			ang = v:GetAngles(), 
			mode = v.mode or 1,
			fencepos = v.post:GetPos()
		}
	end

	ix.data.Set("forcefields", data)
end

function PLUGIN:LoadData()
	for _, v in ipairs(ix.data.Get("forcefields") or {}) do
		local field = ents.Create("ix_forcefield")

		field.noCorrect = true
		field.forcePos = v.fencepos
		field:SetPos(v.pos);
		field:SetAngles(v.ang);
		field:Spawn();
		field.mode = v.mode or 1;
		field:SetDTInt(0, field.mode);
	end
end

function PLUGIN:KeyPress(player, key)
	local data = {};
	data.start = player:GetShootPos();
	data.endpos = data.start + player:GetAimVector() * 84;
	data.filter = player;
	local trace = util.TraceLine(data);
	local entity = trace.Entity;

	if (key == IN_USE and IsValid(entity) and entity:GetClass() == "ix_forcefield") then
		entity:Use(player, player, USE_ON, 1);
	end;
end;