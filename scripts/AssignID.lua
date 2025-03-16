---Assigns an ID to the Provided Entity, make sure to only give it Entities of type "linked-container"!
---@param Player LuaPlayer
---@param Entity LuaEntity
---@param Containers table
---@param New boolean
---@return integer
---@nodiscard
local function AssignID(Player, Entity, Containers, New)
	local ForceName = Player.force.name
	if Debug then log("Force Name: " .. ForceName) end
	local EntityName = Entity.name
	if Debug then log("Entity Name: " .. EntityName) end
	local Links = storage.forces[ForceName][EntityName].links
	if Debug then log("Links: " .. serpent.block(Links)) end
	local LinkID = 0
	--New == true If no neighbour with link_id present or link_id is 0.
	if New then
		if table_size(Containers) > 1 then
			--Attempts to find a Neighbour that already has a link_id set.
			for ID, Neighbour in pairs(Containers) do
				if Neighbour.link_id > 0 then
					if Debug then log('Using Neighbour "' .. serpent.line(Neighbour) .. '" with link_id "' .. Neighbour.link_id .. '".') end
					LinkID = ID
				end
			end
			if Debug then log("Link ID after Neighbour Search: " .. LinkID) end
		end
		--If no Neighbour has a link_id already or there are no Neighbours then we attempt to find an empty link_id.
		if LinkID == 0 then
			for ID, Link in pairs(Links) do
				if Link == nil then
					if Debug then log('Using Empty Link ID "' .. ID .. '".') end
					LinkID = ID
				end
			end
			if Debug then log("Link ID after Empty ID Search: " .. LinkID) end
		end
		--If we still have no link_id then we will create a new one.
		if LinkID == 0 then
			LinkID = table_size(Links) + 1
			if Debug then log("Created new link_id: " .. LinkID) end
		end
		--If we have found a link_id we will save the current Entity + Neighbours to the LinkID table and set the link_id of the entire Group to the found integer.
		for _, Container in pairs(Containers) do
			if Container.link_id ~= LinkID then
				Container.link_id = LinkID
				Links[LinkID] = Containers
			end
		end
		if Debug then log("New Link #" .. LinkID .. " Group: " .. serpent.block(Links[LinkID])) end
		return LinkID
	else
		LinkID = Containers[2].link_id
		if Debug then log("Using Neighbour link_id: " .. serpent.line(LinkID)) end
		for _, Container in pairs(Containers) do
			if Container.link_id ~= LinkID then
				Container.link_id = LinkID
				Links[LinkID] = Containers
			end
		end
		if Debug then log("Updated Link #" .. LinkID .. " Group: " .. serpent.block(Links[LinkID])) end
		return LinkID
	end
end
return AssignID