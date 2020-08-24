--[[
    Copyright © 2020 Cloud Sixteen

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN
PLUGIN.esp = {}
PLUGIN.esp.updateTime = 1

--[[ Micro-optimizations --]]
local UnPredictedCurTime = UnPredictedCurTime;

-- A function to get the ESP info.
function PLUGIN.esp:GetESPInfo()
	return self.ESPInfo;
end;

-- A function to draw the admin ESP.
function PLUGIN.esp:DrawAdminESP()
	local colorWhite = color_white;
	local curTime = UnPredictedCurTime();

	if (!PLUGIN.NextGetESPInfo or curTime >= PLUGIN.NextGetESPInfo) then
		PLUGIN.NextGetESPInfo = curTime + (PLUGIN.esp.updateTime);
		self.ESPInfo = {};
		
		PLUGIN.esp:GetAdminESPInfo(self.ESPInfo)
	end;
	
	for k, v in pairs(self.ESPInfo or {}) do
		local position = v.position:ToScreen();
		local text, color, height, font;
		
		if (position) then
			if (type(v.text) == "string") then
				ix.util.DrawText(v.text, position.x, position.y, v.color or colorWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
			else			
				for k2, v2 in ipairs(v.text) do	
					local barValue;
					local maximum = 100;

					if (type(v2) == "string") then
						text = v2;
						color = v.color;
					else
						text = v2.text;
						color = v2.color;

						local barNumbers = v2.bar;

						if (type(barNumbers) == "table") then
							barValue = barNumbers.value;
							maximum = barNumbers.max;
						else
							barValue = barNumbers;
						end;
					end;
					
					if (k2 > 1) then
						font = "ixESPText"
						height = draw.GetFontHeight("ixESPText");
					else
						font = "ixESPMainText"
						height = draw.GetFontHeight("ixESPMainText");
					end;

					if (v2.icon) then
						local icon = "icon16/exclamation.png";
						local width = surface.GetTextSize(text);

						if (type(v2.icon == "string") and v2.icon != "") then
							icon = v2.icon;
						end;

						surface.SetDrawColor(255, 255, 255, 255);
						surface.SetMaterial(icon);
						surface.DrawTexturedRect(position.x - (width * 0.40) - height, position.y - height * 0.5, height, height);
					end;

					if (barValue) then
						local barHeight = height * 0.80;
						local barColor = v2.barColor or PLUGIN:GetValueColor(barValue);
						local grayColor = Color(150, 150, 150, 170);
						local progress = 100 * (barValue / maximum);

						if progress < 0 then
							progress = 0;
						end;

						draw.RoundedBox(6, position.x - 50, position.y - (barHeight * 0.45), 100, barHeight, grayColor);
						draw.RoundedBox(6, position.x - 50, position.y - (barHeight * 0.45), math.floor(progress), barHeight, barColor);
					end;

					if (type(text) == "string") then
						ix.util.DrawText(text, position.x, position.y, color or colorWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, font, alpha)
					end;

					position.y = position.y + height;
				end;
			end;			
		end;
	end;
end;

function PLUGIN.esp:GetAdminESPInfo(info)
	for k, v in pairs(player.GetAll()) do
		if (v:GetCharacter() and v != LocalPlayer()) then			
			local physBone = v:LookupBone("ValveBiped.Bip01_Head1");
			local position = nil;
								
			if (physBone) then
				local bonePosition = v:GetBonePosition(physBone);
						
				if (bonePosition) then
					position = bonePosition + Vector(0, 0, 16);
				end;
			else
				position = v:GetPos() + Vector(0, 0, 80);
			end;

			local topText = {v:Name()};

			hook.Run("GetStatusInfo", v, topText);	

			local text = {
				{
					text = table.concat(topText, " "), 
					color = v:GetCharacter():GetClassColor()
				}
			};

			hook.Run("GetPlayerESPInfo", v, text);

			table.insert(info, {
				position = position,
				text = text
			});
		end;
	end;

	if (ix.option.Get("observerShowItemESP", true)) then
		for k, v in pairs (ents.GetAll()) do 
			if (v:GetClass() == "ix_item") then
				if (v:IsValid()) then
					local position = v:GetPos();
					local itemTable = v:GetItemTable()

					if (itemTable) then
						if(!ix.option.Get("observerHideLiterature", true) and (itemTable.uniqueID == "notepad" or itemTable.uniqueID == "paper")) then
							continue
						end

						local itemName = itemTable:GetName()
						local color = Color(0, 255, 255, 255);

						table.insert(info, {
							position = position,
							text = {
								{
									text = "Item",
									color = color
								},
								{
									text = itemName,
									color = color
								}
							}
						});
					end;
				end;
			end;
		end;
	end;

	if (ix.option.Get("observerShowVendor", true)) then
		for k, v in pairs (ents.GetAll()) do 
			if (v:GetClass() == "ix_vendor") then
				if (v:IsValid()) then
					local position = v:GetPos();

					local color = Color(100, 180, 255, 255);

					table.insert(info, {
						position = position,
						text = {
							{
								text = "Vendor",
								color = color
							},
							{
								text = v:GetDisplayName(),
								color = color
							}
						}
					})
				end;
			end;
		end;
	end;
end;

-- Called to get the action text of a player.
function PLUGIN:GetStatusInfo(player, text)
	if (player:GetMoveType() == MOVETYPE_NOCLIP) then
		table.insert(text, "[Observer]");
	end;
end;

-- Called when extra player info is needed.
function PLUGIN:GetPlayerESPInfo(player, text)
	if (player:IsValid()) then
		local weapon = player:GetActiveWeapon();
		local health = player:Health();
		local armor = player:Armor();
		local colorWhite = Color(255, 255, 255, 255);
		local colorRed = Color(255, 0, 0, 255);
		local colorHealth = self:GetValueColor(health);
		local colorArmor = self:GetValueColor(armor);
		
		table.insert(text, {
			text = player:SteamName(), 
			color = Color(170, 170, 170, 255), 
			icon = Material(hook.Run("GetPlayerIcon", player))
		});

		if (player:Alive() and health > 0) then
			table.insert(text, {
				text = "Health: ["..health.."]", 
				color = colorHealth, 
				bar = {
					value = health,
					max = player:GetMaxHealth()
				}
			});
			
			if (player:Armor() > 0) then
				table.insert(text, {
					text = "Armor: ["..armor.."]",
					color = colorArmor, 
					bar = {
						value = armor,
						max = 100
					}, 
					barColor = Color(30, 65, 175, 255)
				});
			end;
		
			if (weapon and IsValid(weapon)) then			
				local raised = player:IsWepRaised();
				local color = colorWhite;

				if (raised == true) then
					color = colorRed;
				end;
				
				if (weapon.GetPrintName) then
					local printName = weapon:GetPrintName();

					if (printName) then
						table.insert(text, {
							text = printName, 
							color = color
						});
					end;
				end;
			end;
		end;
	end;
end;

function PLUGIN:GetValueColor(value)
	local red = math.floor(255 - (value * 2.55));
	local green = math.floor(value * 2.55);
	
	return Color(red, green, 0, 255);
end;
