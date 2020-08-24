--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ITEM.base = "base_fullfit";
ITEM.name = "Civil Factory Supervisor Uniform";
ITEM.category = "Clothing - MCS";
ITEM.flag = "A"
ITEM.description = "A complete uniform kit that includes a gas mask, air canister, polyester jacket, steel toed jack boots,hard cut resistant ballistic gloves and more.";
ITEM.maxArmor = 5;
ITEM.gasImmunity = true
ITEM.replacements = "models/hlvr/characters/worker/npc/worker_citizen.mdl"
ITEM.newSkin = 1
ITEM.bodyGroups = {
	["Uniform Variant"] = 1
}
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