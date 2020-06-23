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
	if(faction.name == "Citizen") then
		ix.infoMenu.Add("Citizen ID: #" .. character:GetData("cid"))
	end

	ix.infoMenu.Add("Tokens: " .. ix.currency.Get(character:GetMoney()))

	if(faction.name == "Civil Protection") then
		local cpData = cpSystem.GetCPDataAsTable(character)

		ix.infoMenu.Add("Tagline: " .. cpSystem.GetCPTagline(character))
		ix.infoMenu.Add("Rank: " .. cpData.cpRank)

		if(cpData.spec) then
			ix.infoMenu.Add("Specialization: " .. cpData.spec)
		end

		ix.infoMenu.Add("Certs: " .. ix.certs.GetCertsAsString(character) or "N/A")
	end
end