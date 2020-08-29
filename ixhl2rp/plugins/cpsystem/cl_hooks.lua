--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN
local socioStatus = PLUGIN.socioStatus or "GREEN";

surface.CreateFont( "HUDFont", {
	font = "BudgetLabel",
	size = 16,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "NameFont", {
	font = "BudgetLabel",
	size = 18,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = true,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

function PLUGIN:HUDPaint()
    PLUGIN:HUDPaintForeground();
    PLUGIN:HUDPaintTopScreen();		
end;

function PLUGIN:HUDPaintForeground()
    local clientEyePos = LocalPlayer():EyePos()

    if (LocalPlayer():IsCombine()) then
		for _, v in pairs(player.GetAll() ) do
			if (v:IsCombine() and v:Alive() and clientEyePos:Distance(v:GetPos()) <= self.maximumDistance and not v:GetMoveType() == MOVETYPE_NOCLIP) then
		        local Position = ( v:GetPos() + Vector( 0,0,80 ) ):ToScreen()
			
			    if (v:IsCombine()) then
					draw.DrawText( v:Name(), "NameFont", Position.x, Position.y + 15, cpSystem.color, 1 )		        
					if(ptTeam != "" and v:GetFaction() == FACTION_MPF) then 
			            draw.DrawText( "<:: PT-"..ptTeam.." ::>", "NameFont", Position.x, Position.y - 5, cpSystem.color, 1 )
			        end;
			    end;
				
			    if (v:Health() <= 0) then
				    draw.DrawText( "<:: !WARN: NO VITAL SIGNS! ::>", self.font, Position.x, Position.y + 81, cpSystem.colormal, 1 )
			    elseif (v:Health() <= 10) then
				    draw.DrawText( "<:: !ATT: NEAR DEATH. ::>", self.font, Position.x, Position.y + 31, cpSystem.colormal, 1 )
			    elseif (v:Health() <= 96) then
				    draw.DrawText( "<:: !NOTIF: INJURY DETECTED. ::>", self.font, Position.x, Position.y + 31, coloryel, 1 )
			    end;

			    if (v:IsRagdolled() and v:Alive()) then
				    draw.DrawText( "<:: !NOTIF: UNCONSCIOUS. ::>", self.font, Position.x, Position.y + 81, cpSystem.coloryel, 1 )
			    elseif (v:GetSharedVar("tied") != 0 and !v:IsCombine()) then
				    draw.DrawText( "<:: !NOTIF: RESTRAINED. ::>", self.font, Position.x, Position.y + 44, cpSystem.colorgre, 1 )
			    elseif (v:GetSharedVar("tied") != 0 and v:IsCombine()) then
				    draw.DrawText( "<:: !ATT: RESTRAINED UNIT! ::>", self.font, Position.x, Position.y + 44, cpSystem.coloryel, 1 )
			    end;

			    if (v:FlashlightIsOn()) then
					draw.DrawText( "<:: !NOTIF: USING FLASHLIGHT. ::>", self.font, Position.x, Position.y + 57, cpSystem.colorgre, 1 )
			    end;

				if (v:IsOnFire()) then
					draw.DrawText( "<:: !ATT: ON FIRE. ::>", self.font, Position.x, Position.y + 57, cpSystem.colormal, 1 )					
				end;
				
				if(!v:IsCombine()) then 
				    if (v:InVehicle()) then
					    draw.DrawText( "<:: !ATT: UNAUTHORIZED VEHICLE USAGE. ::>", self.font, Position.x, Position.y + 57, cpSystem.colormal, 1 )
				    elseif (v:IsRunning() or v:IsJogging() and !v:IsCombine()) then
					    draw.DrawText( "<:: !ATT: MOBILE VIOLATION. ::>", self.font, Position.x, Position.y + 57, cpSystem.coloryel, 1 )
				    elseif (v:Crouching() and !v:IsCombine()) then
					    draw.DrawText( "<:: !ATT: STEALTH ATTEMPT. ::>", self.font, Position.x, Position.y + 57, cpSystem.coloryel, 1 )
				    elseif (v:Crouching() and v:IsCombine()) then
					    draw.DrawText( "<:: !NOTIF: IN-STEALTH. ::>", self.font, Position.x, Position.y + 57, cpSystem.colorgre, 1 )
					end;
				end;					
			end;
		end;	   
    end;	
end;

netstream.Hook("RecalculateHUDObjectives", function(status)
	socioStatus = status;
end)

function PLUGIN:HUDPaintTopScreen()
	local blackFadeAlpha = 0;
	local colorWhite = color_white;

	local info = { x = ScrW() - 8, y = 8 };

	if (LocalPlayer():IsCombine()) then
		local height = draw.GetFontHeight("BudgetLabel");

		local socioColor = self.sociostatusColors[socioStatus] or colorWhite;

		if (socioStatus == "BLACK") then
			local tsin = TimedSin(1, 0, 255, 0);
			socioColor = Color(tsin, tsin, tsin);
		end;

		socioColor = Color(socioColor.r, socioColor.g, socioColor.b, 255 - blackFadeAlpha);

		draw.SimpleText("<:: Sociostatus = "..socioStatus.." ::>", "BudgetLabel", info.x, info.y, socioColor, TEXT_ALIGN_RIGHT);
		
		info.y = info.y + height;
		
		for k, v in ipairs(self.hudObjectives) do
			local textColor = Color(colorWhite.r, colorWhite.g, colorWhite.b, 255 - blackFadeAlpha);
				
			draw.SimpleText(v, "BudgetLabel", info.x, info.y, textColor, TEXT_ALIGN_RIGHT);
				
			info.y = info.y + height;
		end;
	end;
end;

netstream.Hook("ReceiveTaglineCache", function(cache)
	cpSystem.cache.taglines = {}
	cpSystem.cache.taglines = cache
end)