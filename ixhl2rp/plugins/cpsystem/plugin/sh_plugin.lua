--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

-- Includes all the metropolice pack files.
do
    local directory = "models/dpfilms/metropolice/";
	local files, folders = _file.Find(directory .. "*.mdl", "GAME");

	for _, obj in pairs(files) do
        ix.anim.SetModelClass(directory .. obj, "metrocop");
	end;
end;