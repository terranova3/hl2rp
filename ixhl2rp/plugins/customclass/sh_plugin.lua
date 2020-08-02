--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

PLUGIN.name = "Custom Class";
PLUGIN.description = "Adds custom class functionality for the scoreboard.";
PLUGIN.author = "Adolphus";

ix.util.IncludeDir(PLUGIN.folder .. "/commands", true)
ix.util.IncludeDir(PLUGIN.folder .. "/meta", true)

ix.config.Add( "runClassHook", false, "Should plugin run PlayerJoinedClass hook?", nil, {
	category = "Perma Class"
} )

if SERVER then
	function PLUGIN:PlayerJoinedClass( ply, classInd, prevClass )		
		local character = ply:GetCharacter()

		if(character:GetFaction() == FACTION_MPF) then
			return 
		end

		if character then
			character:SetData( "pclass", classInd )
		end
	end

	function PLUGIN:PlayerLoadedCharacter( ply, curChar, prevChar )
		local character = ply:GetCharacter()

		if(character:GetFaction() == FACTION_MPF) then
			return 
		end

		local data = curChar:GetData( "pclass" )
		if data then
			local class = ix.class.list[ data ]
			if class then
				local oldClass = curChar:GetClass()

				if ply:Team() == class.faction then
					timer.Simple( .3, function()
						curChar:SetClass( class.index )

						if ix.config.Get( "runClassHook", false ) then
							hook.Run( "PlayerJoinedClass", ply, class.index, oldClass )
						end
					end )
				end
			end
		end
	end
end
