local gradient = ix.util.GetMaterial("vgui/gradient-r.vtf")

local PANEL = {}

function PANEL:Init()
	if (IsValid(ix.gui.intro)) then
		ix.gui.intro:Remove()
	end

	ix.gui.intro = self
	self:SetSize(ScrW(), ScrH())
	self:SetZPos(9999)
	self.loaded = false
end

function PANEL:StartIntro()
	LocalPlayer():EmitSound("music/hl2_song10.mp3", 150, 70)

	self.name = self:Add("DLabel")
	self.name:SetText("Terra Nova")
	self.name:SetFont("ixPluginIntroTitleFont")
	self.name:SetTextColor(color_white)
	self.name:SizeToContents()
	self.name:Center()
	self.name:SetPos(self.name.x, ScrH() * 0.4)
	self.name:SetExpensiveShadow(2, color_black)

	self.cover = self.name:Add("DPanel")
	self.cover:SetSize(ScrW(), self.name:GetTall())
	self.cover.Paint = function(this, w, h)
		surface.SetDrawColor(0, 0, 0)
		surface.SetMaterial(gradient)
		surface.DrawTexturedRect(0, 0, 100, h)

		surface.DrawRect(100, 0, ScrW(), h)
	end
	self.cover:SetPos(-100, 0)

	self.schema = self:Add("DLabel")
	self.schema:SetText("Half-Life 2 Roleplay")
	self.schema:SetFont("ixPluginIntroSubtitleFont")
	self.schema:SizeToContents()
	self.schema:Center()
	self.schema:MoveBelow(self.name, 10)
	self.schema:SetAlpha(0)
	self.schema:SetExpensiveShadow(2, color_black)

	pcall(ix.option.Set, "showIntro", false)
	
	self.cover:MoveTo(self.name:GetWide(), 0, 7.5, 2.5, nil, function()
		self.delta = 0

		self.schema:AlphaTo(255, 5, 1, function()
			self:addContinue()
		end)
	end)
end

function PANEL:ShowRules()

end;

function PANEL:addContinue()
	self.info = self:Add("DLabel")
	self.info:Dock(BOTTOM)
	self.info:SetTall(36)
	self.info:DockMargin(0, 0, 0, 32)
	self.info:SetText("Press Space to continue...")
	self.info:SetFont("ixPluginIntroSmallFont")
	self.info:SetContentAlignment(2)
	self.info:SetAlpha(0)
	self.info:AlphaTo(255, 1, 0, function()
		self.info.Paint = function(this)
			this:SetAlpha(math.abs(math.cos(RealTime() * 0.8) * 255))
		end
	end)
	self.info:SetExpensiveShadow(1, color_black)
end

function PANEL:Think()
	if(IsValid(ix.gui.characterMenu) and !self.closing) then
		ix.gui.characterMenu:SetAlpha(0)
		ix.gui.characterMenu:SetVisible(false)
	end

	if(IsValid(LocalPlayer()) and !self.loaded) then
		self.loaded = true
		self:StartIntro();
	end

	if (IsValid(self.info) and input.IsKeyDown(KEY_SPACE) and !self.closing) then
		self.closing = true

		ix.gui.characterMenu:SetVisible(true)
		ix.gui.characterMenu:AlphaTo(255, 2.5, 0)
		
		self:AlphaTo(0, 2.5, 0, function()
			self:Remove()
		end)
	end
end

function PANEL:OnRemove()
	if (self.sound) then
		self.sound:Stop()
		self.sound = nil

		if (IsValid(ix.gui.characterMenu)) then
			ix.gui.characterMenu:PlayMusic()
		end
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(0, 0, 0)
	surface.DrawRect(0, 0, w, h)
end

vgui.Register("ixPluginIntro", PANEL, "EditablePanel")

-- Override default introduction.
function PLUGIN:LoadIntro()
	vgui.Create("ixPluginIntro")
end