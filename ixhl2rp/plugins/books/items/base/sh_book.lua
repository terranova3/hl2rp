--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Book Base"
ITEM.model = "models/props_lab/clipboard.mdl"
ITEM.description = "This books description has not been setup. This is likely an error, please report this as a bug."
ITEM.category = "Literature"
ITEM.functions.Place = {
	OnRun = function(item)
		local client = item.player
        local trace = client:GetEyeTraceNoCursor();
        
		if (trace.HitPos:Distance( client:GetShootPos() ) <= 192) then			
            local entity = ents.Create("ix_book");
            
            entity:SetModel(item.model);
            entity:SetBook(item.id);
            entity:SetPos(trace.HitPos);
            entity:Spawn();

            ix.entity.MakeFlushToSurface(entity, trace.HitPos, trace.HitNormal);
		else
			client:Notify("You cannot drop a light that far away!");
			
			return false;
		end;
	end;
}
ITEM:Call("Setup")

function ITEM:Setup()
	if (self.bookInformation) then
		self.bookInformation = string.gsub( string.gsub(self.bookInformation, "\n", "<br>"), "\t", string.rep("&nbsp;", 4) );
		self.bookInformation = "<html>"..self.bookInformation.."</html>";
	end;
end