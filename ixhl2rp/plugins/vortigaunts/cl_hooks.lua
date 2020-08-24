--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

-- Called when screen space effects should be rendered.
function PLUGIN:RenderScreenspaceEffects()
	local nvActive = LocalPlayer():GetData("nvActive");
	
	if (nvActive) then	
		local colorModify = {};
			colorModify["$pp_colour_brightness"] = 0.1;
			colorModify["$pp_colour_contrast"] = 0.9;
			colorModify["$pp_colour_colour"] = 0.1;
			colorModify["$pp_colour_addr"] = -0.05;
			colorModify["$pp_colour_addg"] = 0.1;
			colorModify["$pp_colour_addb"] = -0.05;
			colorModify["$pp_colour_mulr"] = 0;
			colorModify["$pp_colour_mulg"] = 5;
			colorModify["$pp_colour_mulb"] = 0;
		DrawColorModify(colorModify);
	end;
end;

function PLUGIN:ShouldDisableLegs()
	if(!LocalPlayer():GetCharacter()) then return false end
	
	local faction = LocalPlayer():GetCharacter():GetFaction()

	if(faction == FACTION_VORT or faction == FACTION_BIOTIC) then
		return true
	end
end