---Assigns an ID to the Provided Entity, make sure to only give it Entities of type "linked-container"!
---@param Player LuaPlayer
<<<<<<< Updated upstream
---@param Entity LuaEntity
---@param EntityName string
---@param SidedContainers table
---@param New boolean
local function AssignID(Player, Entity, EntityName, SidedContainers, New)
	local ForceName = Player.force.name
	local Links = storage.forces[ForceName][EntityName].links
	local LinkID = 0
	--New == true If no neighbour with link_id present or link_id is 0.
	if New then
		for ID, Link in pairs(Links) do
			if Link == {} then
				LinkID = ID
			end
		end
		if LinkID == 0 then
			LinkID = table_size(Links) + 1
			for _, Container in pairs(SidedContainers) do
				if Container.link_id ~= LinkID then
					Container.link_id = LinkID
				end
			end
			Links[LinkID] = SidedContainers
		end
	else
		LinkID = SidedContainers[2].link_id
		Entity.link_id = LinkID
		Links[LinkID] = SidedContainers
	end
	ContainerUpgrade(Player, Entity)
=======
---@param Containers table
---@return integer
---@nodiscard
local function AssignID(Player, Containers)
	assert(Player ~= nil and Player.object_name == "LuaPlayer", "Parameter Player is  " .. serpent.block(Player))
	if Debug then log("Parameter Player: " .. serpent.line(Player)) end

	assert(Containers ~= nil and type(Containers) == "table" and table_size(Containers) > 0, "Parameter Containers is " .. serpent.block(Containers))
	if Debug then log("Parameter Containers: " .. serpent.block(Containers)) end

	local ForceName = Player.force.name
	assert(ForceName ~= nil and type(ForceName) == "string" and game.forces[ForceName].valid, "ForceName: " .. serpent.line(ForceName))
	if Debug then log("Force Name: " .. ForceName) end

	local EntityName = Containers[1].name
	assert(EntityName ~= nil and type(EntityName) == "string" and prototypes.entity[EntityName].valid, "EntityName " .. serpent.line(EntityName) .. " is valid: " .. tostring(prototypes.entity[EntityName].valid))
	if Debug then log("EntityName " .. serpent.line(EntityName) .. " is valid: " .. tostring(prototypes.entity[EntityName].valid)) end

	local Links = storage.forces[ForceName][EntityName].links
	assert(Links ~= nil and type(Links) == "table", "Links: " .. serpent.block(Links))
	if Debug then log("\nLinks: " .. serpent.block(Links)) end

	local LinkID = 0

	if table_size(Links) > 0 then
		--Attempts to find an empty link_id.
		for i = 1, table_size(Links), 1 do
			if table_size(Links[tostring(i)]) == 0 then
				LinkID = i
				if Debug then log('Using Empty Link ID "' .. LinkID .. '".') end
			end
		end
		if Debug then log("Link ID after Empty ID Search: " .. LinkID) end
	end

	if table_size(Containers) > 1 and LinkID == 0 then
		--Attempts to find a Neighbour that already has a link_id set.
		for _, Neighbour in pairs(Containers) do
			if Neighbour.link_id > 0 then
				LinkID = Neighbour.link_id
				if Debug then log('Using Neighbour ' .. serpent.line(Neighbour) .. ' with link_id "' .. LinkID .. '".') end
			end
		end
		if Debug then log("Link ID after Neighbour Search: " .. LinkID) end
	end

	if LinkID == 0 then
		--If we cant find an empty link_id then we will create a new one.
		if LinkID == 0 then
			LinkID = table_size(Links) + 1
			if Debug then log("Created new link_id: " .. LinkID) end
		end
	end

	assert(LinkID > 0, "We cant proceed without a valid LinkID.")
	if Debug then log("LinkID: " .. serpent.line(LinkID)) end

	--At this point we assume to have a link_id, we will save the current Entity + Neighbours to the LinkID table and set the link_id of the entire Group to the found integer.
	for _, Container in pairs(Containers) do
		if Container.link_id ~= LinkID then
			Container.link_id = LinkID
			Links[tostring(LinkID)] = Containers
		end
	end
	if Debug then log('Link "' .. LinkID .. '"\nGroup: ' .. serpent.block(Links[tostring(LinkID)])) end

	if Debug then log("Returning: " .. LinkID) end
	return LinkID
>>>>>>> Stashed changes
end
return AssignID