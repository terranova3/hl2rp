function PLUGIN:EntityFireBullets(ent, bullet)
	if (ent.FiredBullet) then return; end;

	local tr = util.QuickTrace(bullet.Src, bullet.Dir * 10000, ent);

	if (IsValid(tr.Entity) and tr.Entity:GetClass() == "z_forcefield") then
		for i = 1, (bullet.Num or 1) do
			local newbullet = table.Copy(bullet);
			newbullet.Src = tr.HitPos + tr.Normal * 1;

			ent.FiredBullet = true;
			ent:FireBullets(newbullet);
			ent.FiredBullet = false;
		end;

		return false;
	end;
end