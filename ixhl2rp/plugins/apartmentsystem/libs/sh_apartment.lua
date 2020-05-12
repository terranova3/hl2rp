--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

PLUGIN.sections = PLUGIN.sections or {}
PLUGIN.categories = {}

function PLUGIN:AddApartment(section, door)
	if (IsValid(door) and door:IsDoor()) then
		local section = self:GetApartmentSection(section);
		local doorName = string.format("%s - Apartment %s", section.prefix, section.count);
		local doors = {};

		table.insert(doors, door);
		if (IsValid(door:GetDoorPartner())) then
			table.insert(doors, door:GetDoorPartner());
		end

		for i = 1, #doors do
            self:SetupDoor(section, doors[i]);
		end;

        PrintTable(doors);
        
		local apartment = {
			section = section.name,
			doors = doors,
			owners = {}
		}

		section.count = section.count + 1;
		table.insert(section.apartments, apartment)

		PLUGIN:SaveApartmentData();
	end;
end;

function PLUGIN:SetupDoor(section, door)
	local doorName = string.format("%s - Apartment %s", section.prefix, section.count);

	door:SetNetVar("visible", true)
	door:SetNetVar("ownable", nil)
	door:SetNetVar("name", doorName)
end;

function PLUGIN:AddApartmentDoor(id, door)
	local apartment = self:GetApartment(id);

	if(apartment) then
		table.insert(apartment.doors, door);
		PLUGIN:SaveApartmentData();
	end;
end;

function PLUGIN:AddApartmentSection(category, name, prefix, count, apartments, loading)
	local section = {
		name = name,
		prefix = prefix,
		category = category,
		apartments = apartments or {},
		count = count or 1
	}
	table.insert(self.sections, section);

	if(!loading) then
		PLUGIN:SaveApartmentData()
	end;
end;

function PLUGIN:AddApartmentCategory(name, loyalty)
	local category = {
		name = name,
		loyalty = loyalty or 0
	}
	table.insert(self.categories, category);
end;

function PLUGIN:GetApartment(id)
	for i = 1, #self.sections.apartments do
		if(self.sections.apartments[i] and i == id) then
			return self.sections.apartments[i];
		end;
	end;

	return nil;
end;

function PLUGIN:GetApartmentSection(name)
	for i = 1, #self.sections do
		if(self.sections[i].name == name) then 
			return self.sections[i], true;
		end;
	end;

	return nil;
end;

function PLUGIN:GetApartmentCategory(name)
	for i = 1, #self.categories do
		if(self.categories[i].name == name) then 
			return self.categories[i];
		end;
	end;

	return nil;
end;