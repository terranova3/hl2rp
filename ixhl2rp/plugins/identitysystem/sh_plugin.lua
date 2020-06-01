PLUGIN.name = "Identity System"
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.description = "A comprehensive identity system to allow for deeper espionage roleplay."

ix.util.Include("cl_panels.lua")

local PLUGIN = PLUGIN

if CLIENT then
	netstream.Hook("OpenCIDMenu", function(data)
		vgui.Create("ixCIDCreater")
	end)

	netstream.Hook("LoyaltyOpen", function(data)
		local ui = vgui.Create("ixLoyalty")
		ui.ent = data[1]
	end)
else
	netstream.Hook("SubmitNewCID", function(ply, data)
		if ply:IsCombine() then
			local char = ply:GetCharacter()
			local inv = char:GetInventory()
			local Timestamp = os.time()
			local TimeString = os.date("%H:%M:%S - %d/%m/%Y", Timestamp)

			local data2 = {
				["citizen_name"] = data[1],
				["cid"] = math.random(10000, 99999),
				["issue_date"] = TimeString,
				["officer"] = ply:Name()
			}

			inv:Add("cid", 1, data2)
			ply:EmitSound("buttons/button14.wav", 100, 25)
			ply:ForceSequence("harassfront1")
			ix.log.AddRaw(ply:Name() .. " has created a new CID with the name " .. data[1])
		end
	end)
end

function PLUGIN:OnCharacterCreated(client, character)
	if(character:GetFaction() != FACTION_CITIZEN) then return false end
	
	local inventory = character:GetInventory()
	local TimeString = os.date( "%H:%M:%S - %d/%m/%Y", os.time() )

	inventory:Add("suitcase", 1)
	inventory:Add("transfer_papers", 1, {
		citizen_name = character:GetName(),
		unique = math.random(0000000,999999999),
		issue_date = tostring(TimeString)
	})
end
