local CHAR = ix.meta.character

function CHAR:GetClassName()
	return ix.class.list[self:GetClass()].name;
end;

function CHAR:GetSpec()
	if(self:GetData("spec") != nil) then
		return ix.certs.Get(self:GetData("spec"))
	end

	return nil
end

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

function CHAR:GetCerts()
	local data = {}

	for k, v in pairs(self:GetData("certs")) do
		local cert = ix.certs.Get(v)

		table.insert(data, cert)
	end

	return data
end

function CHAR:GetRank()
	return ix.ranks.Get(self:GetData("rank")) or nil
end

function CHAR:GetRankBodygroups()
	return ix.ranks.Get(self:GetData("rank")).bodygroups or nil
end

function CHAR:HasOverride()
	if(self:GetPlayer():IsAdmin()) then
		return true
	end

	return false
end

function CHAR:SetupRankBodygroups()
	if(!self:GetRank()) then
		return
	end
	
	if(hook.Run("SetupRankBodygroups", self)) then
		for k, v in pairs(self:GetRankBodygroups()) do
			self:GetPlayer():SetBodygroup(k, v)
		end
	end
end