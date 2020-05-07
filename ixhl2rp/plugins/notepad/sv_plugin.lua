--[[
	� 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local PLUGIN = PLUGIN;

netstream.Hook("EditNotepad", function(player, data)
	print("hello!")
	if (IsValid( data[1] )) then
		if (data[1]:GetClass() == "ix_notepad") then
			if (player:GetPos():Distance( data[1]:GetPos() ) <= 192 and player:GetEyeTraceNoCursor().Entity == data[1]) then
				if (string.len( data[2] ) > 0) then
					data[1]:SetText( string.sub(data[2], 0, 500) );
				end;
			end;
		end;
	end;
end);