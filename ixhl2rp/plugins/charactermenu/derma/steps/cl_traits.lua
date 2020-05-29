local PANEL = {}

function PANEL:Init()
	self.titleLabel = self:AddLabel("Select traits")
	self.subLabel = self:SubLabel("You may select up to five traits that suit your character.")
end

vgui.Register("ixCharacterTraits", PANEL, "ixCharacterCreateStep")
