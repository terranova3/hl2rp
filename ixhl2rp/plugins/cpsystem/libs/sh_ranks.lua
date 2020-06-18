Schema.ranks = {}
Schema.ranks.stored = {}
Schema.ranks.access = {}
Schema.ranks.access.stored = {}

function Schema.ranks.Add(text, access, armband)
	Schema.ranks.stored[string.lower(text)] = {
		text = text,
		access = access,
		armband = armband or 0
	}
end

function Schema.ranks.Get(text)
	text = string.lower(text)

	return Schema.ranks.stored[text]
end

function Schema.ranks.access.Add(id, text, abbreviation)
	id = string.lower(id)

	Schema.ranks.access.stored[id] = {
		id = id,
		text = text,
		abbreviation = abbreviation
	}
end

function Schema.ranks.access.Get(id)
    id = string.lower(id)
    
	return Schema.ranks.access.stored[id]
end

function Schema.ranks.access.GetSize()
	local count = 1;

	for i = 0, #Schema.ranks.access.stored do
		count = count + 1;
	end;
    
	return count;
end
