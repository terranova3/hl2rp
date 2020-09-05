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

function PLUGIN:ShowHelp() return false end

function PLUGIN:PlayerBindPress(client, bind, pressed)
	if (bind:lower():find("gm_showhelp") and pressed) then

		if (LocalPlayer():GetCharacter()) then
            ix.infoMenu.Display()
		end

		return true
	end
end

-- Called when the info menu is created.
function PLUGIN:SetInfoMenuData(character, faction)
	if(character:GetData("cid") != nil) then
		ix.infoMenu.Add("Citizen ID: #" .. character:GetData("cid"))
	end

	if(character:GetWage()) then
		ix.infoMenu.Add(string.format("Wage: %s tokens", character:GetWage()))
	end

	ix.infoMenu.Add("Tokens: " .. ix.currency.Get(character:GetMoney()))

	if(faction.name == "Civil Protection") then
		local cpData = character:GetCPInfo()

		ix.infoMenu.Add("Tagline: " .. character:GetCPTagline())
		ix.infoMenu.Add("Rank: " .. character:GetRank().displayName)

		if(cpData.spec) then
			ix.infoMenu.Add("Specialization: " .. character:GetSpec().name)
		end
	end
end