local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetPos(4, 4);
	self:SetSize(self:GetWide() - 8, 24);
	self:SetBackgroundColor(Color(100,100,100,5));
	
	self.label = vgui.Create("DLabel", self);
	self.label:SetText("");
	self.label:SetFont("ixSmallFont")
	self.label:SetTextColor(Color(255, 255, 255, 255));
	--self.label:SetExpensiveShadow(1, Color(0, 0, 0, 150));
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout(w, h)	
	self.label:SetPos(8, h / 2 - self.label:GetTall() / 2);

	derma.SkinHook("Layout", "Panel", self);
end;

-- Called when the panel is painted.
function PANEL:Paint(w, h)
	if (self:GetPaintBackground()) then
		local width, height = self:GetSize();
		local color = self:GetBackgroundColor();

		derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, color)
	end	

	return true;
end;

-- A function to set the text to the left.
function PANEL:SetTextToLeft(bValue)
	self.textToLeft = bValue;
end;

-- A function to set the text of the panel.
function PANEL:SetText(text)
	self.label:SetText(text);
	self.label:SizeToContents();
end;

function PANEL:SetInfoColor(color) end

function PANEL:MakeBold()
	self:SetBackgroundColor(Color(100,100,100,25));
end
	
vgui.Register("ixInfoText", PANEL, "DPanel");