--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

-- Called when a new character has been created.
function PLUGIN:CharCreate(character, data)
	local query;

	-- Add a new MySQL row for the new character.
	query:Callback(function(_, _, lastID)
		local charPanelQuery = mysql:Insert("ix_charpanels")
			charPanelQuery:Insert("character_id", lastID)
			charPanelQuery:Callback(function(_, _, panelLastID)
				local charPanel = ix.charPanel.CreateCharPanel(panelLastID);

				character.vars.charPanel = {charPanel}
				charPanel:SetOwner(lastID)
			end)
			charPanelQuery:Execute()
	end)
	query:Execute()
end;

-- Called when server is starting, if the database doesnt exist it will create.
function PLUGIN:DatabaseConnected()
    local query

	-- New table to hold character panel data.
	query = mysql:Create("ix_charpanels")
		query:Create("panel_id", "INT(11) UNSIGNED NOT NULL AUTO_INCREMENT")
		query:Create("character_id", "INT(11) UNSIGNED NOT NULL")
		query:PrimaryKey("panel_id")
	query:Execute()

	-- Added panel_id to the item table.
	query = mysql:Create("ix_items")
		query:Create("item_id", "INT(11) UNSIGNED NOT NULL AUTO_INCREMENT")
		query:Create("inventory_id", "INT(11) UNSIGNED NOT NULL")
		query:Create("panel_id", "INT(11) UNSIGNED NOT NULL")
		query:Create("unique_id", "VARCHAR(60) NOT NULL")
		query:Create("character_id", "INT(11) UNSIGNED DEFAULT NULL")
		query:Create("player_id", "VARCHAR(20) DEFAULT NULL")
		query:Create("data", "TEXT DEFAULT NULL")
		query:Create("x", "SMALLINT(4) NOT NULL")
		query:Create("y", "SMALLINT(4) NOT NULL")
		query:PrimaryKey("item_id")
	query:Execute()
end;

-- Called when all tables are being wiped.
function PLUGIN:OnWipeTables()
    local query

    query = mysql:Drop("ix_charpanels")
	query:Execute()
end