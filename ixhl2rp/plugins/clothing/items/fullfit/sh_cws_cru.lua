--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ITEM.base = "base_fullfit";
ITEM.name = "CRU XHMS Suit";
ITEM.category = "Clothing - MCS";
ITEM.flag = "A"
ITEM.description = "CRU Xen Hazardous Materials Suit. A complete uniform kit that includes a vulcanized rubber jacket, contamination suit, air canister,gas mask, steel toed jackboots, rubber gloves and more.";
ITEM.maxArmor = 25;
ITEM.gasImmunity = true
ITEM.replacements = "models/hlvr/characters/hazmat_worker/npc/hazmat_worker_citizen.mdl"
ITEM.functions.Issue = {
	OnRun = function(itemTable)
		netstream.Start(itemTable.player, "IssueItem", itemTable.id)
		return false
	end,
	OnCanRun = function(item)
		return item.player:GetCharacter():IsCWU() and item:GetData("bNotIssued", true)
	end
}

function ITEM:PopulateTooltip(tooltip)
	if(self:GetData("cid")) then
		local desc = tooltip:AddRow("warning")
		desc:SetText("Issued to: #".. self:GetData("cid", "N/A") .. "\n")
		desc:SizeToContents()
	end

	local warning = tooltip:AddRow("warning")
	warning:SetBackgroundColor(derma.GetColor("Error", tooltip))
	warning:SetText("Contains an RFID chip. Used for gaining access to union locks.")
	warning:SetFont("DermaDefault")
	warning:SetExpensiveShadow(0.5)
	warning:SizeToContents()
end