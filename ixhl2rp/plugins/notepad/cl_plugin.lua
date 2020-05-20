--[[
	� 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local PLUGIN = PLUGIN;

netstream.Hook("ViewNotepad", function(entity, title, text)
	if (IsValid(entity)) then
		if (IsValid(PLUGIN.notepadPanel)) then
			PLUGIN.notepadPanel:Close();
			PLUGIN.notepadPanel:Remove();
		end;
		
		PLUGIN.notepadPanel = vgui.Create("cwViewNotepad");
		PLUGIN.notepadPanel:SetEntity( entity );
		PLUGIN.notepadPanel:Populate( title, text );
		PLUGIN.notepadPanel:MakePopup();
		
		gui.EnableScreenClicker(true);
	end;
end);

netstream.Hook("EditNotepad", function(entity, title, text)
		if (IsValid(PLUGIN.notepadPanel)) then
			PLUGIN.notepadPanel:Close();
			PLUGIN.notepadPanel:Remove();
		end;

		PLUGIN.notepadPanel = vgui.Create("cwEditNotepad");
		PLUGIN.notepadPanel:SetEntity( entity );
		PLUGIN.notepadPanel:Populate( title, text );
		PLUGIN.notepadPanel:MakePopup();
		
		gui.EnableScreenClicker(true);
end);