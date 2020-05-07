--[[
	� 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local PLUGIN = PLUGIN;

netstream.Hook("EditNotepad", function(client, entity, text)
	if (IsValid(entity)) then
		if (entity:GetClass() == "ix_notepad") then
			if (client:GetPos():Distance( entity:GetPos() ) <= 192 and client:GetEyeTraceNoCursor().Entity == entity) then
				if (string.len( text ) > 0) then
					entity:SetText( string.sub(text, 0, 500) );
					entity:SetCharacter(client:GetCharacter().id)
				end;
			end;
		end;
	end;
end);