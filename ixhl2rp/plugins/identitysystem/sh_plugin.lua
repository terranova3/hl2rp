PLUGIN.name = "Employment"
PLUGIN.author = "Adolphus"
PLUGIN.description = "Adds a basic employment system using ID terminals to give paygrades and occupation names."

ix.util.Include("sv_hooks.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/commands", true)
ix.util.IncludeDir(PLUGIN.folder .. "/meta", true)

local PLUGIN = PLUGIN
PLUGIN.paygrades = {
	["Unemployed"] = 0,
	["Paygrade - 1"] = 5,
	["Paygrade - 2"] = 10,
	["Paygrade - 3"] = 15,
	["Paygrade - 4"] = 20,
	["Paygrade - 5"] = 25,
	["Paygrade - 6"] = 30,
	["Paygrade - 7"] = 35,
}

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

			if(data.item) then
				inventory:Remove(data.item)
			end

			local isCombine = false

			for _, v in pairs(player.GetAll()) do
				if(v:GetCharacter() and v:GetCharacter():GetData("cid", "") == data[2]) then
					isCombine = v:GetCharacter():IsCombine()
					break
				end
			end

			local format = "%A, %B %d, %Y. %H:%M:%S"

			inventory:Add("cid", 1, {
				citizen_name = data[1],
				cid = data[2],
				paygrade = data[3],
				salary = data[4],
				employment = data[5],
				issue_date = ix.date.GetFormatted(format),
				officer = client:Name(),
				cca = isCombine
			})

			client:EmitSound("buttons/button14.wav", 100, 25)

			if(character:IsMetropolice()) then
				client:ForceSequence("harassfront1")
			end

			ix.log.AddRaw(client:Name() .. " has created a new CID with the name " .. data[1])
		end
	end)
end