ITEM.name = "Tinder Box";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.category = "Other"
ITEM.business = true;
ITEM.flag = "v"
ITEM.description = "A box containing a few small logs and a flint and tinder to create a small controlled fire. The fire can be used for cooking certain items.";
ITEM.functions.Use = {
	OnRun = function(item)
		local client = item.player
		local trace = client:GetEyeTraceNoCursor();
	
		if (trace.HitPos:Distance( client:GetShootPos() ) <= 192) then
			local entity = ents.Create("ix_campfire");
			
			--entity:SetModel(self.model);
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
				entity:SetPos(trace.HitPos + (entity:GetPos() - entity:NearestPoint(trace.HitPos - (trace.HitNormal * 512))));
			end;
		else
			client:Notify("You cannot create a campfire that far away!");
			
			return false;
		end;
	end;
}
