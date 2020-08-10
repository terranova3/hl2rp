local PANEL = {}
local lightGray = Color(240, 240, 240);
local lightBlue = Color(100, 180, 230);

function PANEL:Init()
	self:SetSize(ScrW() * 0.2, ScrH() * 0.4);
	self:Center();
	self:DockPadding(0, 10, 0, 10);
	self:MakePopup();

	self.closebutton = self:Add("DButton");
	self.closebutton:SetText("");
	self.closebutton.Paint = function(button, w, h)
		local roundW = math.floor(w / 4);
		local roundH = math.floor(h / 4);

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
	end;

	self.header = self:Add("DLabel");
	self.header:SetFont("ffHeader");
	self.header:SetText("PLACEHOLDER");
	self.header:SetTextColor(lightGray);
	self.header:SetContentAlignment(5);
	self.header:DockMargin(10, 0, 10, 0);
	self.header:SizeToContents();
	self.header:Dock(TOP);

	self.scroll = self:Add("DScrollPanel");
	self.scroll:DockMargin(10, 10, 10, 0);
	self.scroll:Dock(FILL);

	self.scroll.VBar.btnUp:Hide();
	self.scroll.VBar.btnDown:Hide();

	self.scroll.VBar.Paint = function() end;
	self.scroll.VBar.btnGrip.Paint = function(grip, w, h)
		DisableClipping(true);
		surface.SetDrawColor(50, 50, 50);
		surface.DrawRect(7, -w, w - 7, h + w * 2);
		DisableClipping(false);
	end;
end;

function PANEL:Paint(w, h)
	surface.SetDrawColor(30, 30, 30);
	surface.DrawRect(0, 0, w, h);
end;

function PANEL:Populate()
	self.scroll:Clear();

	local teamList = ix.class.Get(Class);

	for class, classTable in SortedPairs(teamList) do
		for key, faction in pairs(classTable["factions"]) do
			if (client:IsCombine() or client:Team() == FACTION_ADMIN) then
				local className = classTable["name"]
				local entry = vgui.Create("forcefieldToggleButton", self.scroll);

				entry:DockMargin(1, 0, 1, 2);
				entry:Dock(TOP);

				entry:SetText(className);

				if (IsValid(LocalPlayer():GetNWEntity("ffTarget", nil))) then
					local forcefield = LocalPlayer():GetNWEntity("ffTarget", nil);
					entry:SetEnabled(forcefield.AllowedClasses[className]);
				end;

				entry.DoClick = function(button)
					button:Toggle();
					surface.PlaySound("ui/buttonclick.wav");

					if (button:GetEnabled()) then
						netstream.Start("forcefieldRequest", "addClass", className);
					else
						netstream.Start("forcefieldRequest", "removeClass", className);
					end;
				end;

				self.scroll:AddItem(entry);
			end
		end
	end;
end;

function PANEL:OnRemove()
	FFEditing = nil;
end;

function PANEL:SetTitle(text)
	self.header:SetText(text);
	self.header:SizeToContents();
end;

vgui.Register("ffList", PANEL);

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