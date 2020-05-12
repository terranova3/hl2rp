--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

-- uniqueID for apartments
PLUGIN.indicies = PLUGIN.indicies or 0;

-- LUA Autorefresh
PLUGIN.sections = PLUGIN.sections or {}

-- Don't want this to refresh, since its registered in the config file.
PLUGIN.categories = {}

-- Returns if a character's uniqueID is apart of the apartments ownership table.
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

-- Sets up the ix door display
function PLUGIN:SetupDoor(section, door, id)
	local doorName = string.format("%s - Apartment %s", section.prefix, id or section.count);

	door.apartmentID = self.indicies;
	door:SetNetVar("visible", true)
	door:SetNetVar("ownable", nil)
	door:SetNetVar("name", doorName)
end;

-- Adds an apartment to a section table, includes doors.
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
		doors = door;
		doorIDs = ids;
	end;

	for _, v in pairs(doors) do
		self:SetupDoor(section, v);
	end;
	
	local apartment = {
		uniqueID = self.indicies, -- This is the uniqueID used to access this object.
		id = section.count, -- Tracks the actual id in the section table.
		section = section.name,
		doors = doors,
		doorIDs = doorIDs,
		owners = {}
	}

	-- Incrementing the uniqueID for the global table and local section table.
	self.indicies = self.indicies + 1;
	section.count = section.count + 1;

	table.insert(section.apartments, apartment)

	if(!loading) then 
		PLUGIN:SaveApartmentData();
	end;
end;

-- Adds a character's uniqueID to the owner table of an apartment.
function PLUGIN:AddApartmentOwner(character, id)
	local apartment = self:GetApartment(id);

	if(apartment) then
		table.insert(apartment.owners, character:GetID());
	end;
end;

-- Adds a new door to an already registered apartment.
function PLUGIN:AddApartmentDoor(id, door)
	local apartment = self:GetApartment(id);
	local section = self:GetApartmentSection(apartment.section);

	if(apartment) then
		table.insert(apartment.doors, door);
		table.insert(apartment.doorIDs, door:MapCreationID());
		self:SetupDoor(section, door, apartment.id);

		if (IsValid(door:GetDoorPartner())) then
			table.insert(apartment.doors, door:GetDoorPartner());
			table.insert(apartment.doorIDs, door:GetDoorPartner():MapCreationID());
			self:SetupDoor(section, door:GetDoorPartner(), apartment.id);
		end

		PLUGIN:SaveApartmentData();
	end;
end;

-- Adds a new section to hold apartments in.
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

-- Adds a new category, used as a requirement for apartment section assignment.
function PLUGIN:AddApartmentCategory(name, loyalty)
	local category = {
		name = name,
		loyalty = loyalty or 0
	}
	table.insert(self.categories, category);
end;

-- Returns apartment object if it exists.
function PLUGIN:GetApartment(id)
	for i = 1, #self.sections do
		for _, v in pairs(self.sections[i].apartments) do
			if(v.uniqueID == id) then
				return v;
			end;
		end;
	end;

	return nil;
end;

-- Returns section object if it exists.
function PLUGIN:GetApartmentSection(name)
	for i = 1, #self.sections do
		if(self.sections[i].name == name) then 
			return self.sections[i], true;
		end;
	end;

	return nil;
end;

-- Returns category object if it exists.
function PLUGIN:GetApartmentCategory(name)
	for i = 1, #self.categories do
		if(self.categories[i].name == name) then 
			return self.categories[i];
		end;
	end;

	return nil;
end;

-- Uses the door entity to get the door entity from the apartment.
function PLUGIN:GetApartmentDoor(door)
	for k, v in pairs(self.sections.apartments) do
		for i = 1, #v.doors do
			if(v.doors[i] == door) then
				return v.door[i];
			end;
		end;
	end;

	return nil;
end;

-- Returns if a character's uniqueID is apart of the apartments ownership table.
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