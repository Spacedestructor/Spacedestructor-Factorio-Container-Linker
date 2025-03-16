---Finds any Containers present in a Row from current Entity and returns a Table of all Entities.
---@param Entity LuaEntity
---@return table
---@nodiscard
local function FindContainers(Entity)
	local Surface = Entity.surface
	local Position = Entity.position
	local Tiers = settings.startup["Spacedestructor-TierLimit"].value
	local Names = {}
	for i = 1, Tiers, 1 do
		Names[i] = "Spacedestructor-linked-container-2x2-Tier-" .. i
	end
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
	--For each Direction it attempts to find Neighbours ordered from closest to furthest.
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
			local Container = Surface.find_entities_filtered{name = Names, position = {Position.x + Offset.x, Position.y + Offset.y}}
			if table_size(Container) == 0 then
				break
			else
				for Index, Entity in pairs(Container) do
					if string.sub(Entity.name, 1, 42) == "Spacedestructor-linked-container-2x2-Tier-" then
						table.insert(Containers[Direction], table_size(Containers[Direction]) + 1, Entity)
					end
				end
			end
		end
	end
	if Debug then log("Returning Containers: " .. serpent.block(Containers)) end
	return Containers
end
return FindContainers