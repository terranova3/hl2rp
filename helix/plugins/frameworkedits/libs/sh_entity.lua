--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.entity = ix.entity or {}

if(SERVER) then
    -- A function to make an entity flush with the ground after it has been spawned.
	function ix.entity.MakeFlushToSurface(entity, position, normal)
		entity:SetPos(position + (entity:GetPos() - entity:NearestPoint(position - (normal * 512))));
    end;

    function ix.entity.SetClient(entity, client)
		entity:SetNetworkedEntity("Client", client);
	end;
end