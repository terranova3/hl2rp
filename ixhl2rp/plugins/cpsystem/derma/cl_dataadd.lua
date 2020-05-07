local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetBackgroundBlur(false);
	self:SetDeleteOnClose(false);

	-- Called when the button is clicked.
	function self.btnClose.DoClick(button)
		self:Close();
      self:Remove();
	end;
end;

-- Called each frame.
function PANEL:Think()
	local scrW = ScrW();
	local scrH = ScrH();

	self:SetSize(320, 180);
	self:SetPos( (scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2) );
end;

-- A function to populate the panel.
function PANEL:Populate(motherPanel)
   if (!ispanel(motherPanel)) then
      self:Close();
      self:Remove();
   end;

	self:SetTitle("Add Record");

   local doneButton = vgui.Create("DButton", self);
   doneButton:SetText("Add");
   doneButton:DockMargin(0, 4, 0, 0);
   doneButton:Dock(BOTTOM);

   local panel = vgui.Create("DPanel", self);
   panel:Dock(FILL);

      local width = 320 - 10 - 8;

      local entryReason = vgui.Create("DTextEntry", panel);
      entryReason:SetSize(width, 25);
      entryReason:SetPos(4, 4);
      entryReason:SetText("Reason");

      local entryType = vgui.Create("DComboBox", panel);
      entryType:SetSize((width * 0.7) - 4, 25);
      entryType:SetPos(4, 4 + 25 + 4);
      entryType:SetValue("Type");
      entryType:AddChoice("Penalty");
      entryType:AddChoice("Loyalty");

      local entryAmount = vgui.Create("DNumberWang", panel);
      entryAmount:SetSize(width * 0.3, 25);
      entryAmount:SetPos(4 + (width * 0.7) + 1, 4 + 25 + 4);
      entryAmount:SetMinMax(1, 128);
      entryAmount:SetValue(1);

	-- Called when the button is clicked.
	function doneButton.DoClick(button)
		self:Close();
      self:Remove();

      if (!ispanel(motherPanel)) then
         return;
      end;

      local newData = {
         rsn = entryReason:GetText(),
         usr = LocalPlayer():GetName(),
         loy = (entryType:GetSelected() == "Loyalty"),
         num = entryAmount:GetValue()
      };

      table.insert(motherPanel.dataPoints, newData);
      motherPanel:PopulateRecords();
   	motherPanel:PopulateRichText();
	end;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	DFrame.PerformLayout(self);
end;

vgui.Register("cwDataDraft", PANEL, "DFrame");
