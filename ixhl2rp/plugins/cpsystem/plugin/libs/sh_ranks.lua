Schema.ranks = {}
Schema.ranks.stored = {}
Schema.ranks.classes = {}
Schema.ranks.access = {}
Schema.ranks.access.stored = {}

function Schema.ranks.Add(text, access)
	text = string.lower(text)

	Schema.ranks.stored[text] = {
		access = access
	}
end

function Schema.ranks.Get(text)
	text = string.lower(text)

	return Schema.ranks.stored[text]
end

function Schema.ranks.access.Add(id, text, abbreviation)
	id = string.lower(id)

	Schema.ranks.access.stored[id] = {
		text = text,
		abbreviation = abbreviation
	}
end

function Schema.ranks.access.Get(id)
    id = string.lower(id)
    
	return Schema.ranks.access.stored[id]
end
