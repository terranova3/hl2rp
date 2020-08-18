ITEM.name = "Union Light";
ITEM.cost = 50;
ITEM.model = "models/props_combine/combine_light001a.mdl";
ITEM.category = "Utilities"
ITEM.noBusiness = true
ITEM.description = "A Union Light capable of illuminating large areas.";
ITEM.functions.Place = {
	OnRun = function(item)
		local client = item.player
		local trace = client:GetEyeTraceNoCursor();
		local entity = ents.Create("ix_unionlight");

		if (trace.HitPos:Distance( client:GetShootPos() ) <= 192) then			
			entity:SetModel("models/props_combine/combine_light001a.mdl");
			entity:SetPos(trace.HitPos);
			entity:Spawn();
			
			if ( IsValid(itemEntity) ) then
				local physicsObject = itemEntity:GetPhysicsObject();
				
				entity:SetPos( itemEntity:GetPos() );
				entity:SetAngles( itemEntity:GetAngles() );
				
				if ( IsValid(physicsObject) ) then
					if ( !physicsObject:IsMoveable() ) then
						physicsObject = entity:GetPhysicsObject();
						
						if ( IsValid(physicsObject) ) then
							physicsObject:EnableMotion(false);
						end;
					end;
				end;
			else
				entity:SetPos(trace.HitPos + (entity:GetPos() - entity:NearestPoint(trace.HitPos - (trace.HitNormal * 512))));
			end;
		else
			client:Notify("You cannot drop a light that far away!");
			
			return false;
		end;
	end;
}
