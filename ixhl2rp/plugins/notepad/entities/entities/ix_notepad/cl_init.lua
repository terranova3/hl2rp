--[[
	� 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

include("shared.lua");

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();
end;

function ENT:OnPopulateEntityInfo(container)
	local name = container:AddRow("name")
	name:SetImportant()
	name:SetText("Notepad")
	name:SizeToContents()

	local descriptionText;

	if(self:GetDTBool(0)) then
		descriptionText = "It has been written on.";
	else
		descriptionText = "It is blank.";
	end;

	local description = container:AddRow("description")
	description:SetText(descriptionText)
	description:SizeToContents()
end

-- Called when an entity's menu options are needed.
function ENT:GetEntityMenu(client)
	local options = {}

	if (self:GetDTBool(0)) then
		options["Read"] = "";
		options["Edit"] = "";
	else
		options["Write"] = "";
	end;

	return options;
end;