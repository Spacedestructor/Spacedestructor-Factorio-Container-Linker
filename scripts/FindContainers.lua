---Finds any Containers present in a Row from current Entity and returns a Table of all Entities.
---@param Entity LuaEntity
---@return table
---@nodiscard
local function FindContainers(Entity)
	local Surface = Entity.surface
	local Position = Entity.position
	local Tiers = settings.startup["Spacedestructor-TierLimit"].value
	local Containers = {
		top = {
			Entity
		},
		right = {
			Entity
		},
		bottom = {
			Entity
		},
		left = {
			Entity
		}
	}
	for _, Direction in pairs({"top", "right", "bottom", "left"}) do
		for i = 1, Tiers-1, 1 do
			local Offset = {x = 0, y = 0}
			if Direction == "top" then
				Offset = {x = 0, y = -(2 * i)}
			elseif Direction == "right" then
				Offset = {x = (2 * i), y = 0}
			elseif Direction == "bottom" then
				Offset = {x = 0, y = (2 * i)}
			elseif Direction == "left" then
				Offset = {x = -(2 * i), y = 0}
			end
			local Container = Surface.find_entity(Entity.name, {Position.x + Offset.x, Position.y + Offset.y})
			if Container == nil then
				break
			else
				table.insert(Containers[Direction], table_size(Containers[Direction]) + 1, Container)
			end
		end
	end
	return Containers
end
return FindContainers