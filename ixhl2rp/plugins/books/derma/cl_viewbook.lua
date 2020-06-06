--[[
    Copyright © 2020 Cloud Sixteen

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetBackgroundBlur(true);
	self:SetDeleteOnClose(false);
	
	-- Called when the button is clicked.
	function self.btnClose.DoClick(button)
		self:Close(); self:Remove();
		
		gui.EnableScreenClicker(false);
	end;
end;

-- Called each frame.
function PANEL:Think()
	local scrW = ScrW();
	local scrH = ScrH();
	
	self:SetSize(512, 512);
	self:SetPos( (scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2) );
	
	if (!IsValid(self.entity) or self.entity:GetPos():Distance( LocalPlayer():GetPos() ) > 192) then
		self:Close(); self:Remove();
		
		gui.EnableScreenClicker(false);
	end;
end;

-- A function to set the panel's entity.
function PANEL:SetEntity(entity)
	self.entity = entity;
end;

-- A function to populate the panel.
function PANEL:Populate(itemTable)
	self:SetTitle(itemTable.name);
	
	self.htmlPanel = vgui.Create("HTML", self);
	self.htmlPanel:SetHTML(itemTable.bookInformation);
	self.htmlPanel:SetWrap(true);
	
	self.button = vgui.Create("DButton", self);
	self.button:SetText("Take");
	self.button:SetWide(504);
	self.button:SetPos(4, 486);
	
	-- Called when the button is clicked.
	function self.button.DoClick(button)
		self:Close(); self:Remove();
		
		gui.EnableScreenClicker(false);
		
		if (IsValid(self.entity)) then
			netstream.Start("TakeBook", self.entity);
		end;
	end;
	
	gui.EnableScreenClicker(true);
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.htmlPanel:StretchToParent(4, 28, 4, 30);
	
	DFrame.PerformLayout(self);
end;

vgui.Register("ixViewBook", PANEL, "DFrame");