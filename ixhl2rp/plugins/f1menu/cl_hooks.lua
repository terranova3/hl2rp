--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

function PLUGIN:ShouldHideBars()
	if(ix.infoMenu.open) then
		return true
	end
end

-- Called each tick.
function PLUGIN:Tick()
	if (IsValid(LocalPlayer()) and LocalPlayer():GetCharacter()) then
		if (ix.infoMenu.open and !input.IsKeyDown(KEY_F1)) then
			ix.infoMenu.open = false;
			
			if (IsValid(ix.infoMenu.panel)) then
				ix.infoMenu.panel:Remove();
				CloseDermaMenus()
			end;
		end
	end
end;

-- Called when the info menu is created.
function PLUGIN:SetInfoMenuData(character, faction)
	if(faction.name == "Citizen") then
		ix.infoMenu.Add("Citizen ID: #" .. character:GetData("cid"))
	end

	ix.infoMenu.Add("Tokens: " .. ix.currency.Get(character:GetMoney()))

	if(faction.name == "Civil Protection") then
		local cpData = cpSystem.GetCPDataAsTable(character)

		ix.infoMenu.Add("Tagline: " .. cpSystem.GetCPTagline(character))
		ix.infoMenu.Add("Rank: " .. cpData.cpRank)
	end
end