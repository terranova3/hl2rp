--[[
	� 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local PLUGIN = PLUGIN;

netstream.Hook("ViewNotepad", function(data)
	if (IsValid(data[1])) then
		if (IsValid(PLUGIN.notepadPanel)) then
			PLUGIN.notepadPanel:Close();
			PLUGIN.notepadPanel:Remove();
		end;
		
		if (!data[3]) then
			local uniqueID = data[2];
			
			if (PLUGIN.notepadIDs[uniqueID]) then
				data[3] = PLUGIN.notepadIDs[uniqueID];
			else
				data[3] = "Error!";
			end;
		else
			local uniqueID = data[2];
			
			PLUGIN.notepadIDs[uniqueID] = data[3];
		end;
		
		PLUGIN.notepadPanel = vgui.Create("cwViewNotepad");
		PLUGIN.notepadPanel:SetEntity( data[1] );
		PLUGIN.notepadPanel:Populate( data[3] );
		PLUGIN.notepadPanel:MakePopup();
		
		gui.EnableScreenClicker(true);
	end;
end);

netstream.Hook("EditNotepad", function(data)
	if (IsValid(data[1])) then
		if (IsValid(PLUGIN.notepadPanel)) then
			PLUGIN.notepadPanel:Close();
			PLUGIN.notepadPanel:Remove();
		end;
		
		if (!data[3]) then
			local uniqueID = data[2];
			
			if (PLUGIN.notepadIDs[uniqueID]) then
				data[3] = PLUGIN.notepadIDs[uniqueID];
			else
				data[3] = "";
			end;
		else
			local uniqueID = data[2];
			
			PLUGIN.notepadIDs[uniqueID] = data[3];
		end;
		
		PLUGIN.notepadPanel = vgui.Create("cwEditNotepad");
		PLUGIN.notepadPanel:SetEntity( data[1] );
		PLUGIN.notepadPanel:Populate( data[3] );
		PLUGIN.notepadPanel:MakePopup();
		
		gui.EnableScreenClicker(true);
	end;
end);