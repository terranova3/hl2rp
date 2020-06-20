local CHAR = ix.meta.character
local cLIST = ix.class.list;

function CHAR:IsCombine()
	local faction = self:GetPlayer():Team();
	local isCombine = (faction == FACTION_OTA or faction == FACTION_SCN);

	if(faction == FACTION_MPF and !self:IsUndercover()) then
		isCombine = true;
	end;

	return isCombine;
end

function CHAR:IsUndercover()
	if(self:GetClass() != nil) then 
		if(self:GetFaction() == FACTION_MPF and self:GetClassName() == "Metropolice Unit Undercover") then
			return true;
		else
			return false;
		end;
	else
		return false;
	end;
end;

function CHAR:GetClassName()
	return ix.class.list[self:GetClass()].name;
end;

function CHAR:HasCert(uniqueID)
	if(self:HasSpec(uniqueID)) then
		return true
	end

	for k, v in pairs(self:GetData("certs", {})) do
		if(v == uniqueID) then
			return true
		end
	end

	return false
end

function CHAR:HasSpec(uniqueID)
	if(self:GetData("spec") and spec == uniqueID) then
		return true
	end

	return false
end