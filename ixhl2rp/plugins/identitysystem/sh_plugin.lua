PLUGIN.name = "Identity System"
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.description = "A comprehensive identity system to allow for deeper espionage roleplay."

ix.util.Include("sv_hooks.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/commands", true)

local PLUGIN = PLUGIN

if CLIENT then
	netstream.Hook("OpenCIDMenu", function(data)
		vgui.Create("ixCIDCreater")
	end)

	netstream.Hook("OpenRecordMenu", function(data)
		vgui.Create("ixRecordPanel")
		--ix.gui.cidview:SetItem(ix.item.instances[data[1]])

		if(IsValid(ix.gui.menu)) then
			ix.gui.menu:Remove()
		end
	end)

	netstream.Hook("ViewData", function(target, cid, data, cpData)
		Schema:AddCombineDisplayMessage("@cViewData")
		vgui.Create("ixRecordPanel"):Build(target, cid, data, cpData)
	end)
else
	netstream.Hook("IDAddRecord", function(ply, data)
		local item = ix.item.instances[data[4]]
		local before_data = item:GetData("record", {})
		local inbetween_data = {{data[1], data[2], data[3], data[5]}}
		table.Add(before_data, inbetween_data)
		item:SetData("record", before_data)
		item:SetData("points", item:GetData("points", 0) + data[5])
		ix.log.AddRaw(ply:Name() .. " has added a record to ID " .. item:GetID())
	end)

	netstream.Hook("IDRemoveRecord", function(ply, data)
		local item = ix.item.instances[data[4]]
		local before_data = item:GetData("record", {})
		before_data[data[5]] = nil
		item:SetData("record", before_data)
		ix.log.AddRaw(ply:Name() .. " has removed a record from ID " .. item:GetID())
	end)

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
	if(character:GetFaction() == FACTION_CITIZEN) then
		local inventory = character:GetInventory()
		local TimeString = os.date( "%H:%M:%S - %d/%m/%Y", os.time() )

		inventory:Add("suitcase", 1)
		inventory:Add("transfer_papers", 1, {
			citizen_name = character:GetName(),
			unique = math.random(0000000,999999999),
			issue_date = tostring(TimeString)
		})
	end
end
