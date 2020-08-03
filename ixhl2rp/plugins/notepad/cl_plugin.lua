--[[
	� 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local PLUGIN = PLUGIN;

netstream.Hook("ViewNotepad", function(text, id, editMode)
	if (IsValid(PLUGIN.notepadPanel)) then
		PLUGIN.notepadPanel:Close();
		PLUGIN.notepadPanel:Remove();
	end;

	if(IsValid(ix.gui.menu)) then
		ix.gui.menu:Remove()
	end
	
	local uiType = "ixViewNotepad"

	if(editMode) then
		uiType = "ixEditNotepad"
	end

	PLUGIN.notepadPanel = vgui.Create(uiType);
	PLUGIN.notepadPanel:Populate(text or "", id or 0);
	PLUGIN.notepadPanel:MakePopup();
	
	gui.EnableScreenClicker(true);
end);