--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

PLUGIN.sections = PLUGIN.sections or {}
PLUGIN.categories = {}

function PLUGIN:HasAccess(character, door)
	if(!door.apartmentID) then return true; end;

	local apartment = PLUGIN:GetApartment(door.apartmentID);

	if(apartment) then
		for _, v in pairs(apartment.owners) do
			if(v == character:GetID()) then
				return true;
			end;	
		end;
	end;

	return false;
end;

function PLUGIN:SetupDoor(section, door)
	local doorName = string.format("%s - Apartment %s", section.prefix, section.count);

	door.apartmentID = section.count;
	door:SetNetVar("visible", true)
	door:SetNetVar("ownable", nil)
	door:SetNetVar("name", doorName)
end;

function PLUGIN:AddApartment(section, door, ids, loading)
	local section = self:GetApartmentSection(section);
	local doors = {}
	local doorIDs = {}

	if(!loading) then 
		table.insert(doors, door);
		table.insert(doorIDs, door:MapCreationID());

		if (IsValid(door:GetDoorPartner())) then
			table.insert(doors, door:GetDoorPartner());
			table.insert(doorIDs, door:GetDoorPartner():MapCreationID());
		end
	else
		doors = ids;
		doors = door;
	end;

	for _, v in pairs(doors) do
		self:SetupDoor(section, v);
	end;
	
	local apartment = {
		section = section.name,
		doors = doors,
		doorIDs = doorIDs,
		owners = {}
	}

	section.count = section.count + 1;
	table.insert(section.apartments, apartment)

	if(!loading) then 
		PLUGIN:SaveApartmentData();
	end;
end;

function PLUGIN:AddApartmentOwner(character, id)
	local apartment = PLUGIN:GetApartment(id);

	if(apartment) then
		table.insert(apartment.owners, character:GetID());
	end;
end;

function PLUGIN:AddApartmentDoor(id, door)
	local apartment = self:GetApartment(id);

	if(apartment) then
		table.insert(apartment.doors, door);
		table.insert(apartment.doorIDs, door:MapCreationID());

		if (IsValid(door:GetDoorPartner())) then
			table.insert(apartment.doors, door:GetDoorPartner());
			table.insert(apartment.doorIDs, door:GetDoorPartner():MapCreationID());
		end
		
		PLUGIN:SaveApartmentData();
	end;
end;

function PLUGIN:AddApartmentSection(category, name, prefix, loading)
	local section = {
		name = name,
		prefix = prefix,
		category = category,
		apartments = {},
		count = 1
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

function PLUGIN:GetApartmentDoor(door)
	for k, v in pairs(self.sections.apartments) do
		if(v.door == door) then
			return v.door;
		end;
	end;

	return nil;
end;