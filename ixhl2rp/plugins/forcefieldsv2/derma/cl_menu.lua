local PANEL = {};
local lightGray = Color(240, 240, 240);
local lightBlue = Color(100, 180, 230);

surface.CreateFont("ffHeader", {
	size = ScreenScale(9),
	font = "Trebuchet24",
	weight = 300,
	antialias = true
});

surface.CreateFont("ffButton", {
	size = ScreenScale(6),
	font = "Trebuchet24",
	weight = 300,
	antialias = true
});

function PANEL:Init()
	self:SetSize(ScrW() * 0.2, ScrH() * 0.25);
	self:Center();
	self:DockPadding(0, 5, 0, 10);
	self:MakePopup();

	self.closebutton = self:Add("DButton");
	self.closebutton:SetText("");
	self.closebutton.Paint = function(button, w, h)
		local roundW = w / 4;
		local roundH = h / 4;

		if (button.h) then
			surface.SetDrawColor(255, 0, 0, 255);
		else
			surface.SetDrawColor(0, 0, 0, 0);
		end;

		surface.DrawRect(0, 0, w, h);

		surface.SetDrawColor(color_white);
		surface.DrawLine(roundW, roundH, w - roundW, h - roundH + 1);
		surface.DrawLine(roundW, h - roundH, w - roundW, roundH - 1);
	end;

	self.closebutton.OnCursorEntered = function(button)
		button.h = true;
	end;

	self.closebutton.OnCursorExited = function(button)
		button.h = false;
	end;

	self.closebutton:SetSize(32, 32);
	self.closebutton:SetPos(self:GetWide() - 32, 0);
	self.closebutton:SetZPos(1000);
	self.closebutton:SetCursor("arrow")
	self.closebutton.UpdateColours = function()
	end;

	self.closebutton.DoClick = function()
		self:Remove();
		FFMenu = nil;
	end;

	self.header = self:Add("DLabel");
	self.header:SetFont("ffHeader")
	self.header:SetTextColor(lightGray);
	self.header:SetText("Access Manager");
	self.header:SetContentAlignment(5);
	self.header:DockMargin(10, 0, 10, 5);
	self.header:SizeToContents();
	self.header:Dock(TOP);

	local buttonSize = (self:GetTall() - self.header:GetTall() - 5 - 15 - 6) / 3;

	self.addClass = self:Add("forcefieldButton");
	self.addClass:SetText("Manage Access");
	self.addClass:SetSize(0, buttonSize);
	self.addClass:DockMargin(10, 0, 10, 2);
	self.addClass:Dock(TOP);
	self.addClass.DoClick = function(button)
		if (!FFEditing) then
			FFEditing = vgui.Create("ffList");
			FFEditing:SetTitle("Access Manager");
			FFEditing:Populate();
		end;
	end;

	self.unionCard = self:Add("forcefieldToggleButton");
	self.unionCard:SetText("Union Card Access");
	self.unionCard:SetSize(0, buttonSize);
	self.unionCard:DockMargin(10, 0, 10, 2);
	self.unionCard:Dock(TOP);

	if (IsValid(LocalPlayer():GetNWEntity("ffTarget", nil))) then
		local forcefield = LocalPlayer():GetNWEntity("ffTarget", nil);

		self.unionCard:SetEnabled(forcefield:GetDTBool(1))
	end

	self.unionCard.DoClick = function(button)
		button:Toggle()
		surface.PlaySound("ui/buttonclick.wav");

		if (button:GetEnabled()) then
			netstream.Start("forcefieldUnionCardRequest", true)
		else
			netstream.Start("forcefieldUnionCardRequest", false)
		end
	end;
end;

function PANEL:Paint(w, h)
	surface.SetDrawColor(30, 30, 30);
	surface.DrawRect(0, 0, w, h / 1.4);
end;

function PANEL:OnRemove()
	netstream.Start("forcefieldEditorClosed")
end;

vgui.Register("forcefieldMenu", PANEL);

local BUTTON = {}

function BUTTON:Init()
	self:SetFont("ffButton");
	self:SetTextColor(lightGray);
	self:SetContentAlignment(5);
end;

function BUTTON:UpdateColours(skin)
end;

function BUTTON:OnCursorEntered()
	self.highlighted = true;
end;

function BUTTON:OnCursorExited()
	self.highlighted = false;
end;

function BUTTON:Paint(w, h)
	local col = self.highlighted and 60 or 70;
	surface.SetDrawColor(col, col, col);
	surface.DrawRect(0, 0, w, h);
end;

vgui.Register("forcefieldButton", BUTTON, "DButton");

local BUTTON = {}

function BUTTON:Init()
	self:SetFont("ffButton");
	self:SetTextColor(lightGray);
	self:SetContentAlignment(5);
	self:SetTall(32);
	self.enabled = false;
end;

function BUTTON:UpdateColours(skin)
end;

function BUTTON:OnCursorEntered()
	self.highlighted = true;
end;

function BUTTON:OnCursorExited()
	self.highlighted = false;
end;

function BUTTON:SetEnabled(bEnabled)
	if (bEnabled) then
		self.enabled = true;
		self:SetTextColor(lightBlue);
	else
		self.enabled = false;
		self:SetTextColor(lightGray);
	end;
end;

function BUTTON:GetEnabled()
	return self.enabled;
end;

function BUTTON:Toggle()
	self:SetEnabled(!self:GetEnabled());
end;

function BUTTON:Paint(w, h)
	local col = self.highlighted and 60 or (self.enabled and 80 or 50);
	surface.SetDrawColor(col, col, col);
	surface.DrawRect(0, 0, w, h);
end;

vgui.Register("forcefieldToggleButton", BUTTON, "DButton");