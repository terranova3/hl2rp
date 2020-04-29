--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ix.config.Add("City Name", "C17", "The abbreviation used for the 'city' value in cpSystem", nil, {
	category = "cpSystem"
})

ix.config.Add("Civil Protection Abbreviation", "CPF", "The abbreviation used for the 'abbreviation' value in cpSystem", nil, {
	category = "cpSystem"
})

ix.config.Add("CP Naming Scheme", "city.abbreviation:rank.tagline-id", "Naming scheme for civil protection units. values: city, abbreviation, rank, tagline, id, division", nil, {
	category = "cpSystem"
})

ix.config.Add("Use Taglines", true, "Use the custom naming scheme for civil protection instead of the default ID system.", nil, {
	category = "cpSystem"
})

ix.config.Add("Incognito Scoreboard", true, "Whether or not Civil Protection will show on the scoreboard.", nil, {
	category = "cpSystem"
})

ix.config.Add("Dispatch Access Level", 1, "The access level that can access dispatch commands.", nil, {
	data = {min = 0, max = 10},
	category = "cpSystem"
})

-- Includes all the metropolice pack files.
do
    local directory = "models/dpfilms/metropolice/";
	local files, folders = file.Find(directory .. "*.mdl", "GAME");

	for _, obj in pairs(files) do
        ix.anim.SetModelClass(directory .. obj, "metrocop");
	end;
end;

