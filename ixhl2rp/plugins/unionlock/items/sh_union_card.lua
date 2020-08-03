ITEM.name = "Civil Access Card"
ITEM.model = Model("models/dorado/tarjeta4.mdl")
ITEM.description = "An old machine manufactured card that used to give the holder access to blue coded combine locks. It had been disabled after the Civil Services card storage was raided."
ITEM.factions = {FACTION_MPF, FACTION_OTA}
ITEM.category = "Other"

function ITEM:PopulateTooltip(tooltip)
	local warning = tooltip:AddRow("warning")
	warning:SetBackgroundColor(derma.GetColor("Error", tooltip))
	warning:SetText("Contains an RFID chip. This card has been disabled.")
	warning:SetFont("DermaDefault")
	warning:SetExpensiveShadow(0.5)
	warning:SizeToContents()
end