--[[
	� 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM.name = "Notepad";
ITEM.cost = 5;
ITEM.model = "models/props_lab/clipboard.mdl";
ITEM.weight = 0.1;
ITEM.flag = "g"
ITEM.category = "Other"
ITEM.description = "A clean notepad, useful for note taking.";
ITEM.functions.Use = {
	OnRun = function(item)
		local client = item.player
		local trace = client:GetEyeTraceNoCursor();
	
		if (trace.HitPos:Distance( client:GetShootPos() ) <= 192) then
			local entity = ents.Create("ix_notepad");
			
			--Clockwork.player:GiveProperty(player, entity);
			
			entity:SetPos(trace.HitPos);
			entity:Spawn();
			
			if (IsValid(itemEntity)) then
				local physicsObject = itemEntity:GetPhysicsObject();
				
				entity:SetPos( itemEntity:GetPos() );
				entity:SetAngles( itemEntity:GetAngles() );
				
				if (IsValid(physicsObject)) then
					if (!physicsObject:IsMoveable()) then
						physicsObject = entity:GetPhysicsObject();
						
						if (IsValid(physicsObject)) then
							physicsObject:EnableMotion(false);
						end;
					end;
				end;
			else
				-- Flush to ground
				entity:SetPos(trace.HitPos + (entity:GetPos() - entity:NearestPoint(trace.HitPos - (trace.HitNormal * 512))));
			end;
		else
			client:Notify("You cannot drop notepads that far away!");
			
			return false;
		end;
	end
}
