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

DEFINE_BASECLASS("base_gmodentity");

ENT.Type = "anim";
ENT.Author = "kurozael";
ENT.PrintName = "Book";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "ID")
	self:NetworkVar("String", 1, "DisplayName")
	self:NetworkVar("String", 2, "Description")
end

function ENT:OnPopulateEntityInfo(container)
	local name = container:AddRow("name")
	name:SetImportant()
	name:SetText(self:GetDisplayName())
	name:SizeToContents()

	local descriptionText = self:GetDescription()

	if (descriptionText != "") then
		local description = container:AddRow("description")
		description:SetText(self:GetDescription())
		description:SizeToContents()
	end
end

function ENT:GetEntityMenu(client)
	options = {
		["View"] = "",
		["Take"] = ""
	}

	return options
end