--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

-- Called when server is starting, if the database doesnt exist it will create.
function PLUGIN:DatabaseConnected()
    local query

	-- New table to hold enterprise data
	query = mysql:Create("ix_enterprises")
		query:Create("enterprise_id", "INT(11) UNSIGNED NOT NULL AUTO_INCREMENT")
		query:Create("owner_id", "INT(11) UNSIGNED NOT NULL")
		query:Create("name", "TEXT DEFAULT NULL")
		query:Create("data", "TEXT DEFAULT NULL")
		query:PrimaryKey("enterprise_id")
	query:Execute()

	self:LoadEnterprises()
end;

function PLUGIN:LoadEnterprises()
	local query

	query = mysql:Select("ix_enterprises")
		query:Select("enterprise_id")
		query:Select("owner_id")
		query:Select("name")
		query:Select("data")
    	query:Callback(function(result)
			if (istable(result) and #result > 0) then
				for k, v in ipairs(result) do
					local data = {}
					local members = {}
					
					-- Loading all of the miscellaneous enterprise data and putting it in a table.
					for k, v in pairs(util.JSONToTable(v.data or "[]")) do
						data[k] = v
					end

					-- Loading all of the characters that are in this enterprise and placing it into a members table
					local membersQuery = mysql:Select("ix_characters")
					membersQuery:Select("id")
					membersQuery:Select("name")
					membersQuery:Select("model")
					membersQuery:Select("enterprise")
					membersQuery:Select("enterpriserank")
					membersQuery:Where("enterprise", tonumber(v.enterprise_id))
					membersQuery:Callback(function(results)
						if(istable(results) and #results > 0) then
							for _, member in ipairs(results) do
								local character = {
									id = member.id,
									name = member.name,
									model = member.model,
									rank = member.enterpriserank
								}
								
								table.insert(members, character)
							end
						end				
					end)				
					membersQuery:Execute()

					-- Giving the enterprise the metatable methods.
					enterprise = setmetatable({
						owner = tonumber(v.owner_id),
						name = v.name,
						data = data,
						members = members
					}, ix.meta.enterprise)

					ix.enterprise.stored[tonumber(v.enterprise_id)] = enterprise

					enterprise = nil
				end
			end
    	end)
	query:Execute()
	PrintTable(ix.enterprise.stored)
end

-- Called when all tables are being wiped.
function PLUGIN:OnWipeTables()
    local query

    query = mysql:Drop("ix_enterprises")
	query:Execute()
end