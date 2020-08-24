ITEM.name = "CRU Card"
ITEM.model = Model("models/dorado/tarjeta3.mdl")
ITEM.description = "A machine manufactured card that gives the holder access to zones locked by the Civil Restoration Union."
ITEM.noBusiness = true
ITEM.category = "Other"
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

if(SERVER) then
	netstream.Hook("SendIssueItem", function(client, id, text)
		for k, v in pairs(client:GetCharacter():GetInventory():GetItems()) do
			if(v.id == id) then
				v:SetData("bNotIssued", false)
				v:SetData("cid", text)

				break
			end
		end
	end)
else
	netstream.Hook("IssueItem", function(id)
		Derma_StringRequest("Issue Civil Access Card", "Put in the CID of the person this will be for", "", function(text)
			netstream.Start("SendIssueItem", id, text)
		end, nil, "Issue", "Cancel")
	end)
end