--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PANEL = {}

-- Called when the panel is first initialized.
function PANEL:Init()
	self:Dock(FILL)
	self:SetDrawBackground(false)
	
	self.backHeader = self:Add(ix.gui.record:AddBackHeader(function()
		ix.gui.record:SendToServer(VIEWDATA_UPDATEVAR, {
			var = "note",
			info = self.textEntry:GetText()
		})
		ix.gui.record:SetStage("Home")
	end))

	local title = self:Add(ix.gui.record:BuildLabel("Editing Note", true))
	title:DockMargin(0,0,0,4)
	
	local recordName = self:Add(ix.gui.record:BuildLabel("You can type up to 1024 characters."))
	recordName:DockMargin(0,0,0,4)

	self.textEntry = self:Add("DTextEntry")
    self.textEntry:SetMultiline(true)
    self.textEntry:DockMargin(8, 0, 8, 8)
	self.textEntry:Dock(FILL)
	self.textEntry:SetText(ix.gui.record:GetRecord().vars["note"] or "")

	function self.textEntry:PerformLayout()
        self:SetBGColor( Color(50, 50, 50, 50) )
	end
	
	-- A function to set the text entry's real value.
	function self.textEntry:SetRealValue(text)
		self:SetValue(text);
		self:SetCaretPos( string.len(text) );
	end;

	-- Called each frame.
	function self.textEntry:Think()
		local text = self:GetValue();

		if (string.len(text) > 1024) then
			self:SetRealValue( string.sub(text, 0, 1024) );

			surface.PlaySound("common/talk.wav");
		end;
	end;
end

vgui.Register("ixCombineViewDataViewNote", PANEL, "DPanel")