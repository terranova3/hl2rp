local CHAR = ix.meta.character
local cLIST = ix.class.list;

function CHAR:IsCombine()
	local isCombine = (faction == FACTION_OTA);

	if(faction == FACTION_MPF and !self:IsUndercover()) then
		isCombine = true;
	else
		isCombine = false;
	end;

	return isCombine;
end

function CHAR:IsMetropolice()
	local faction = self:GetFaction()
	return faction == FACTION_MPF
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
