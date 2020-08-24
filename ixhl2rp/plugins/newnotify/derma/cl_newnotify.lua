--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

DEFINE_BASECLASS("DFrame")

local PANEL = {};
local animationTime = 2

local factionMaterials = {
    ["CITIZEN"] = "materials/terranova/ui/citizen_background.png",
    ["MPF"] = "materials/terranova/ui/mpf_background.png",
}

-- Called when the panel is initialized.
function PANEL:Init()
    if(ix.gui.newnotify) then
        self.animtime = 0.1
        ix.gui.newnotify:Close()
        ix.gui.newnotify = nil
    end

    self.animtime = 2
    ix.gui.newnotify = self

    self:SetDeleteOnClose(false);
    self:SetTitle("");
    self:Center()
    self:ShowCloseButton( false )
end;

-- Called each frame.
function PANEL:Think()
    local scrW = ScrW();
    local scrH = ScrH();

    self:SetSize(512, 256);
    self:SetPos( (scrW / 2) - (self:GetWide() / 2), (scrH - scrH * 0.95)  );
end;

function PANEL:Paint() end;

function PANEL:Populate(data)
    local picture = factionMaterials[data.faction] or factionMaterials[1];

    sound.PlayFile(data.sound, "", function(station, errCode, errStr)
        if(IsValid(station)) then
            station:Play()
        end
    end);

    self.mat = vgui.Create("Material", self)
    self.mat:SetPos(0, 0)
    self.mat:SetSize(512, 256)
    self.mat:SetMaterial(picture)
    self.mat.AutoSize = false

    self.container = self:Add("DPanel");
    self.container:SetPos(50, 60)
    self.container:SetSize(398, 200)
    self.container.Paint = function() end;

    self.headerText = self.container:Add("DLabel")
    self.headerText:SetText(data.title or "")
    self.headerText:Dock(TOP);
    self.headerText:SetContentAlignment(5)
    self.headerText:SetExpensiveShadow(2)
    self.headerText:SetFont("NotifFont1")
    self.headerText:SetSize(self:GetWide(), 48)
    self.headerText:SetPos(0, 0)
    self.headerText:SetTextColor(data.titleColor or Color( 255, 224, 0))

    self.descriptionText = self.container:Add("DLabel")
    self.descriptionText:SetText(data.text or "")
    self.descriptionText:Dock(TOP);
    self.descriptionText:SetContentAlignment(5)
    self.descriptionText:SetExpensiveShadow(2)
    self.descriptionText:SetFont("NotifFont2")
    self.descriptionText:SetSize(self:GetWide(), 32)
    self.descriptionText:SetPos(0, 0)

    self.additionalText = self.container:Add("DLabel")
    self.additionalText:SetText(data.additional or "")
    self.additionalText:Dock(TOP);
    self.additionalText:SetContentAlignment(5)
    self.additionalText:SetExpensiveShadow(2)
    self.additionalText:SetFont("NotifFont2")
    self.additionalText:SetSize(self:GetWide(), 32)
    self.additionalText:SetPos(0, 0)

    self.alpha = 0
    self:SetAlpha(0)


    self:CreateAnimation(animationTime, {
        index = 1,
        target = {alpha = 255},
        easing = "outQuint",

        Think = function(animation, panel)
            panel:SetAlpha(panel.alpha)
            panel.mat:SetAlpha(panel.alpha);
        end
    })

    timer.Simple(7, function() self:Close() end)
end;

function PANEL:Close()
    self:CreateAnimation(self.animTime, {
        target = {alpha = 0},
        easing = "outQuint",

        Think = function(animation, panel)
            panel:SetAlpha(panel.alpha)
            panel.mat:SetAlpha(panel.alpha);
        end,

        OnComplete = function(animation, panel)
            BaseClass.Close(panel)
        end
    })
end


vgui.Register("ixPlayerNotifyNew", PANEL, "DFrame");

net.Receive("PlayerNotify", function()
    currentNotification = vgui.Create("ixPlayerNotifyNew"):Populate(net.ReadTable());
end);
