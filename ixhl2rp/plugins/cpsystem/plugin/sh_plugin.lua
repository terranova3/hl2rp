--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ix.config.Add("cpSystem_CityAbbreviation", "C17", "The abbreviation used for the 'city' value in cpSystem", nil, {
	category = "cpSystem"
})

ix.config.Add("cpSystem_CPName", "city.abbreviation:rank-id", "Naming scheme for civil protection units. values: city, abbreviation, rank, id, division", nil, {
	category = "cpSystem"
})

ix.config.Add("cpSystem_IncognitoScoreboard", true, "Whether or not Civil Protection will show on the scoreboard.", nil, {
	category = "cpSystem"
})

-- Includes all the metropolice pack files.
do
    local directory = "models/dpfilms/metropolice/";
	local files, folders = _file.Find(directory .. "*.mdl", "GAME");

	for _, obj in pairs(files) do
        ix.anim.SetModelClass(directory .. obj, "metrocop");
	end;
end;

