PLUGIN.name = "Item Spawn Menu"
PLUGIN.author = "Robot"
PLUGIN.description = "Adds an item spawn menu for SuperAdmin usage."

if (CLIENT) then
	function PLUGIN:InitializedPlugins(client)
		RunConsoleCommand("spawnmenu_reload")
	end
end