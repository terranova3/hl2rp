Schema.ranks = {}
Schema.ranks.stored = {}
Schema.ranks.classes = {}

function Schema.ranks.Add(class, text, access)
	class = string.lower(class)
	key = string.lower(key)

	Schema.ranks.stored[class] = Schema.ranks.stored[class] or {}
	Schema.ranks.stored[class][key] = {
		text = text,
		access = access
	}
end

function Schema.ranks.Get(class, key)
	class = string.lower(class)
	key = string.lower(key)

	if (Schema.ranks.stored[class]) then
		return Schema.ranks.stored[class][key]
	end
end

function Schema.ranks.AddRankList(class, condition)
	class = string.lower(class)

	Schema.ranks.classes[class] = {
		condition = condition
	}
end

function Schema.ranks.GetRankList(client)
	local classes = {}

	for k, v in pairs(Schema.ranks.classes) do
		if (v.condition(client)) then
			classes[#classes + 1] = k
		end
	end

	return classes
end