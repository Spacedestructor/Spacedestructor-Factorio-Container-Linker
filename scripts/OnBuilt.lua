---Takes any construction event and handles the entire logic for assigning ID's to new constructed containers, upgrade/downgrade and storage cleanup.
---@param Event defines.events
local function OnBuilt(Event)
	---@diagnostic disable-next-line: undefined-field
	local Entity = Event.entity
	if string.sub(Entity.name, 1, 42) == "Spacedestructor-linked-container-2x2-Tier-" then
		if Debug then log("Entity Constructed: " .. serpent.line(Entity)) end

		---@diagnostic disable-next-line: undefined-field
		local Player = game.players[Event.player_index]
		assert(Player ~= nil and Player.object_name == "LuaPlayer", '\nPlayer must be a "LuaPlayer" object but is actually "' .. tostring(Player.object_name) .. '".')
		if Debug then log("Player: " .. serpent.line(Player)) end

		local Containers = FindContainers(Entity)
		assert(type(Containers) == "table", 'Containers must be of type "table" but is actually "' .. type(Containers) .. '".')
		if Debug then log("Containers: " .. serpent.block(Containers)) end

		local Side = FindLargestSizeBiased(Containers)
		if Debug then log("Side: " .. serpent.line(Side)) end
		assert(type(Side) == "string", 'Side must be type "string" but is actually type "' .. type(Side) .. '".')

		Containers = Containers[Side]
		assert(Containers ~= nil and type(Containers) == "table" and table_size(Containers) > 0, 'Containers must contain at least a single Entity but has only "' .. tostring(table_size(Containers)) .. '".')
		if Debug then log("Containers: " .. serpent.block(Containers) .. " Size: " .. table_size(Containers)) end

		local LinkID = AssignID(Player, Containers)
		if Debug then log("Entity: " .. serpent.line(Entity) .. " LinkID: " .. serpent.line(LinkID)) end

		local ForceName = Player.force.name
		assert(ForceName ~= nil and type(ForceName) == "string" and game.forces[ForceName].valid, "ForceName: " .. serpent.line(ForceName))
		if Debug then log("ForceName: " .. serpent.line(ForceName)) end

		local EntityName = Entity.name
		assert(EntityName ~= nil and type(EntityName) == "string" and prototypes.entity[EntityName].valid, "Entity " .. serpent.line(EntityName) .. " is valid: " .. tostring(prototypes.entity[EntityName].valid))
		if Debug then log("links: " .. serpent.block(storage.forces[ForceName][EntityName].links) .. " LinkID: " .. serpent.block(storage.forces[ForceName][EntityName].links[tostring(LinkID)])) end

		local Link = storage.forces[ForceName][EntityName].links[tostring(LinkID)]
		if Debug then log("Link: " .. serpent.block(Link)) end

		local Tier = tonumber(string.sub(Link[1].name, 43, string.len(Link[1].name)))
		local Target = table_size(Link)
		if Target > Tier then
			if Debug then log('Upgrading from Tier "' ..Tier .. '" to Tier "' .. Target .. '".') end
			ContainerUpgrade(Player, Entity)
		else
			if Debug then log("Not upgrading.") end
		end
		if Debug then log('Resulting Storage for Force "' .. ForceName .. '": ' .. serpent.block(storage.forces[ForceName])) end
	end
end
return OnBuilt