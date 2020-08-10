local PLUGIN = PLUGIN;

function PLUGIN:EntityFireBullets(ent, bullet)
	if ent.FiredBullet then return; end;

	for i = 1, bullet.Num do
		local tr = util.QuickTrace(bullet.Src, bullet.Dir * 10000, ent);

		if (IsValid(tr.Entity) and tr.Entity:GetClass() == "ix_forcefield") then
			local newbullet = table.Copy(bullet);
			newbullet.Src = tr.HitPos + tr.Normal * 1;
			newbullet.Attacker = ent;

			ent.FiredBullet = true;
			ent:FireBullets(newbullet);
			ent.FiredBullet = false;

			return false;
		end;
	end;
end;