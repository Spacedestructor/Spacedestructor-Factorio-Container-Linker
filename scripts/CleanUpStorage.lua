---When provided a table such as "links" from Container-Linker the function will remove nil indexes and invalid Entities.
---@param Data any
local function CleanUpStorage(Data)
	log("Processing: " .. serpent.block(Data))
	log("Type: " .. type(Data))
	for key, value in pairs(Data) do
		log("Key: " .. key)
		if type(value) == "table" then
			if table_size(value) == 0 then
				log("Removing empty table: " .. serpent.line(value))
				table.remove(Data, 1)
			else
				log("Found table: " .. serpent.block(value))
				CleanUpStorage(value)
			end
		elseif type(value) == "userdata" then
			---@diagnostic disable-next-line: undefined-field
			if value.valid == false then
				log("Removing invalid Entity: " .. serpent.line(value))
				table.remove(Data, key)
			end
		end
	end
end
return CleanUpStorage