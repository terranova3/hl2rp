PLUGIN.name = "Identity System"
PLUGIN.author = "ZeMysticalTaco, Adolphus"
PLUGIN.description = "A comprehensive identity system to allow for deeper espionage roleplay."

ix.util.Include("sv_hooks.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/commands", true)

local PLUGIN = PLUGIN

if CLIENT then
	netstream.Hook("OpenCIDMenu", function(data)
		vgui.Create("ixCIDCreater")
	end)

	netstream.Hook("ViewData", function(target, cid, data, cpData)
		Schema:AddCombineDisplayMessage("@cViewData")
		vgui.Create("ixRecordPanel"):Build(target, cid, data, cpData)
	end)
else
	netstream.Hook("SubmitNewCID", function(client, data)
		if(client:IsCombine() or client:GetCharacter():HasFlags("i")) then
			local character = client:GetCharacter()
			local inventory = character:GetInventory()

			if(!character or !inventory) then
				return
			end

			if(data[4] == 0) then
				data[4] = nil
			end

			if(data[5]) then
				inventory:Remove(data[5])
			end

			inventory:Add("cid", 1, {
				citizen_name = data[1],
				cid = data[2],
				occupation = data[3],
				salary = data[4],
				issue_date = os.date("%H:%M:%S - %d/%m/%Y", os.time()),
				officer = client:Name()
			})

			client:EmitSound("buttons/button14.wav", 100, 25)

			if(character:IsMetropolice()) then
				client:ForceSequence("harassfront1")
			end

			ix.log.AddRaw(client:Name() .. " has created a new CID with the name " .. data[1])
		end
	end)
end

function PLUGIN:OnCharacterCreated(client, character)
	if(character:GetFaction() == FACTION_CITIZEN) then
		local inventory = character:GetInventory()

		inventory:Add("suitcase", 1)
	end
end
