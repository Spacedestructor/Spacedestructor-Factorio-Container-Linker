---Takes the Name of the Force for which the Prototype Links should be cleaned.
---@param ForceName string
---@param Tier integer
---@param LinkID integer
local function Clean(ForceName, Tier, LinkID)
	assert(ForceName ~= nil and type(ForceName) == "string", "ForceName must be a string!")

	assert(Tier ~= nil and type(Tier) == "number", "Tier must be a number!")

	assert(LinkID ~= nil and type(LinkID) == "number", "LinkID must be a number!")

	while table_size(storage.forces[ForceName]["Spacedestructor-linked-container-2x2-Tier-" .. Tier].links[tostring(LinkID)]) > 0 do
		table.remove(storage.forces[ForceName]["Spacedestructor-linked-container-2x2-Tier-" .. Tier].links[tostring(LinkID)], 1)
	end
	if Debug then log("Results: " .. serpent.block(storage.forces[ForceName])) end
end
return Clean