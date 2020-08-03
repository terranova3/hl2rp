ITEM.name = "Civil Access Card"
ITEM.model = Model("models/dorado/tarjeta4.mdl")
ITEM.description = "A machine manufactured card that gives the holder access to blue coded combine locks."
ITEM.factions = {FACTION_MPF, FACTION_OTA}
ITEM.category = "Other"
ITEM.functions.Issue = {
	OnRun = function(itemTable)
		local client = itemTable.player

		Derma_StringRequest("Issue Civil Access Card", "Put in the CID of the person this will be for", "", function(text)
			itemTable:SetData("bNotIssued", false)
			itemTable:SetData("cid", text)
		end, nil, "Issue", "Cancel")

		return false
	end,
	OnCanRun = function(item)
		return item.player:GetCharacter():GetClass() == CLASS_CWU or item:GetData("bNotIssued", true)
	end
}

function ITEM:PopulateTooltip(tooltip)
	if(self:GetData("cid")) then
		local desc = tooltip:AddRow("warning")
		desc:SetText("Issued to: ".. self:GetData("cid", "N/A"))
		desc:SizeToContents()
	end

	local warning = tooltip:AddRow("warning")
	warning:SetBackgroundColor(derma.GetColor("Error", tooltip))
	warning:SetText("Contains an RFID chip. Used for gaining access to union locks.")
	warning:SetFont("DermaDefault")
	warning:SetExpensiveShadow(0.5)
	warning:SizeToContents()
end