
ITEM.name = "Generic Item"
ITEM.description = "Generic Description"
ITEM.model = Model("models/maxofs2d/hover_rings.mdl")
ITEM.noBusiness = true

function ITEM:GetName()
	return self:GetData("name", "Custom Item")
end

function ITEM:GetDescription()
	return self:GetData("description", "Custom item description.")
end

function ITEM:GetModel()
	return self:GetData("model", "models/Gibs/HGIBS.mdl")
end

function ITEM:PopulateTooltip(tooltip)
	if(!self:GetData("tip") != "") then
		return
	end 

	local data = tooltip:AddRow("data")
	data:SetText("\n" .. self:GetData("tip"))
	data:SetFont("ixPluginCharSubTitleFont")
	data:SizeToContents()
end