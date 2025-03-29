---Ensures on each new save or loaded save that storage is initialized correctly.
local function Init()
	storage.prototypes = storage.prototypes or {}
	storage.forces = storage.forces or {}
	for _, Force in pairs(game.forces) do
		local ForceName = Force.name
		storage.forces[ForceName] = storage.forces[ForceName] or {}
		for _, Prototype in pairs(prototypes.get_entity_filtered({{filter = "type", type = "linked-container"}})) do
			if string.sub(Prototype.name, 1, 42) == "Spacedestructor-linked-container-2x2-Tier-" then
				storage.prototypes[Prototype.name] = true
				storage.forces[ForceName][Prototype.name] = storage.forces[ForceName][Prototype.name] or {}
				storage.forces[ForceName][Prototype.name].links = storage.forces[ForceName][Prototype.name].links or {}
			end
		end
	end
end
return Init