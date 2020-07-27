ITEM.name = "Transfer Papers"
ITEM.model = "models/props_lab/clipboard.mdl"
ITEM.description = "A piece of paper, indicating your new transfer status."
ITEM.category = "Other"
ITEM.noBusiness = true

function ITEM:GetDescription()
	return self.description
end

if (CLIENT) then
    function ITEM:PaintOver(item, w, h)
		ix.util.DrawText("!", w-8, h-19, Color(218,171,3,255), 0, 0, "ixSmallFont")
	end
end

function ITEM:PopulateTooltip(tooltip)
	local data = tooltip:AddRow("data")
	data:SetBackgroundColor(derma.GetColor("Success", tooltip))
	data:SetText("Name: " .. self:GetData("citizen_name", "Unissued") .. "\nTransfer Number: " .. self:GetData("unique", "00000") .. "\nIssue Date: " .. self:GetData("issue_date", "Unissued"))
	data:SetFont("BudgetLabel")
	data:SetExpensiveShadow(0.5 )
	data:SizeToContents()

	local data2 = tooltip:AddRow("data2")
	data2:SetBackgroundColor(derma.GetColor("Warning", tooltip))
	data2:SetText("Take these papers to a civil protection unit, to receive a CID in return. THIS IS NOT VALID IDENTIFICATION.")
	data2:SetFont("DermaDefault")
	data2:SetExpensiveShadow(0.5)
	data2:SizeToContents()
end