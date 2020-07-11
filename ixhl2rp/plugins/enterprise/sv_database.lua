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
end;

-- Called when all tables are being wiped.
function PLUGIN:OnWipeTables()
    local query

    query = mysql:Drop("ix_enterprises")
	query:Execute()
end