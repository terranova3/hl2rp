local CHAR = ix.meta.character

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

function CHAR:GetRank()
	return ix.ranks.Get(self:GetData("rank")) or nil
end

function CHAR:HasOverride()
	if(self:GetPlayer():IsAdmin()) then
		return true
	end

	return false
end