---Manages the IDs on construction.
---@param PlayerIndex uint
---@param Containers table
---@param Entity LuaEntity
local function ManageID(PlayerIndex, Containers, Entity)
	local Side = FindLargestSizeBiased(Containers)
	assert(Side ~= nil, "Failed to get Side!")
	local SidedContainers = Containers[Side]
	local Player = game.players[PlayerIndex]
	local ForceName = Player.force.name
	local EntityName = Entity.name
	if table_size(SidedContainers) == 1 then
		AssignID(Player, Entity, EntityName, SidedContainers, true)
	elseif table_size(SidedContainers) > 1 then
		if SidedContainers[2].link_id > 0 then
			AssignID(Player, Entity, EntityName, SidedContainers, false)
		else
			AssignID(Player, Entity, EntityName, SidedContainers, true)
		end
	end
end
return ManageID