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

	query = mysql:Select("ix_enterprises")
		query:Select("enterprise_id")
		query:Select("owner_id")
		query:Select("name")
		query:Select("data")
    	query:Callback(function(result)
			if (istable(result) and #result > 0) then
				for k, v in ipairs(result) do
					local data = {}
					
					for k, v in pairs(util.JSONToTable(v.data or "[]")) do
						data[k] = v
					end

					enterprise = setmetatable({
						owner = tonumber(v.owner_id),
						name = v.name,
						data = data
					}, ix.meta.enterprise)

					ix.enterprise.stored[tonumber(v.enterprise_id)] = enterprise

					enterprise = nil
				end
			end
    	end)
	query:Execute()

	PrintTable(ix.enterprise.stored)
end;

-- Called when all tables are being wiped.
function PLUGIN:OnWipeTables()
    local query

    query = mysql:Drop("ix_enterprises")
	query:Execute()
end