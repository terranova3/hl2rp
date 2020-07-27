ITEM.name = "Civil Access Card"
ITEM.model = Model("models/dorado/tarjeta4.mdl")
ITEM.description = "A machine manufactured card that gives the holder access to blue coded combine locks."
ITEM.factions = {FACTION_MPF, FACTION_OTA}
ITEM.category = "Other"

function ITEM:PopulateTooltip(tooltip)
	local warning = tooltip:AddRow("warning")
	warning:SetBackgroundColor(derma.GetColor("Error", tooltip))
	warning:SetText("Contains an RFID chip. Used for gaining access to union locks.")
	warning:SetFont("DermaDefault")
	warning:SetExpensiveShadow(0.5)
	warning:SizeToContents()
end