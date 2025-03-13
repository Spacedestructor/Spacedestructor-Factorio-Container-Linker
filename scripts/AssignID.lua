---Assigns an ID to the Provided Entity, make sure to only give it Entities of type "linked-container"!
---@param Player LuaPlayer
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
end
return AssignID