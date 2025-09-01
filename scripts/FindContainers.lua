---Finds any Containers present in a Row from current Entity and returns a Table of all Entities.
---@param Entity LuaEntity
---@return table
---@nodiscard
local function FindContainers(Entity)
	assert(Entity ~= nil and Entity.object_name == "LuaEntity" and Entity.valid == true, 'Entity is "' .. serpent.line(Entity) .. '(' .. type(Entity) .. ', Valid: ' .. tostring(Entity.valid) .. ')".')
	if Debug then log("Parameter Entity: " .. serpent.line(Entity)) end
	local Surface = Entity.surface
	assert(Surface ~= nil and Surface.object_name == "LuaSurface" and Surface.valid == true, 'Surface is "' .. serpent.line(Surface) .. '(' .. type(Surface) .. ', Valid: ' .. tostring(Surface.valid) .. ')".')
	if Debug then log("Surface: " .. serpent.line(Surface)) end
	local Position = Entity.position
	--What can i do to validate Coordinates?
	--I guess we only care of [1] or x and [2] or y are of type "number" to be good enough.
	assert(Position ~= nil and type(Position) == "table" and (type(Position[1]) == "number" or type(Position.x) == "number") and (type(Position[2]) == "number" or type(Position.y) == "number"), 'Position is "' .. serpent.line(Position) .. '(' .. type(Position) .. ', Valid: ' .. tostring((type(Position[1]) == "number" or type(Position.x) == "number") and (type(Position[2]) == "number" or type(Position.y) == "number")) .. ')".')
	if Debug then log("Position: " .. serpent.line(Position)) end
	local Tiers = settings.startup["Spacedestructor-TierLimit"].value
	--No Assert here since Factorio already validates Settings and this is just a simple Integer situation.
	if Debug then log("Tiers: " .. Tiers) end
	local Names = {}
	for i = 1, Tiers, 1 do
		Names[i] = "Spacedestructor-linked-container-2x2-Tier-" .. i
	end
	assert(type(Names) == "table" and table_size(Names) > 0, "Names is " .. type(Names) .. " with size " .. table_size(Names))
	if Debug then log("Names : " .. serpent.block(Names)) end
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
	if Debug then log("Containers: " .. serpent.block(Containers)) end
	local Directions = {"top", "right", "bottom", "left"}
	--For each Direction it attempts to find Neighbours ordered from closest to furthest.
	for _, DirectionName in pairs(Directions) do
		for i = 1, Tiers-1, 1 do
			local Offset = {x = 0, y = 0}
			if DirectionName == "top" then
				Offset = {x = 0, y = -(2 * i)}
			elseif DirectionName == "right" then
				Offset = {x = (2 * i), y = 0}
			elseif DirectionName == "bottom" then
				Offset = {x = 0, y = (2 * i)}
			elseif DirectionName == "left" then
				Offset = {x = -(2 * i), y = 0}
			end
			if Debug then log('Offset: "' .. serpent.line(Offset) .. '" Direction: "' .. DirectionName .. '"') end
			local Container = Surface.find_entities_filtered{name = Names, position = {Position.x + Offset.x, Position.y + Offset.y}}
			if Debug then log("Container: " .. serpent.line(Container)) end
			if table_size(Container) == 0 then
				break
			else
				for Index, Chest in pairs(Container) do
					if string.sub(Chest.name, 1, 42) == "Spacedestructor-linked-container-2x2-Tier-" then
						table.insert(Containers[DirectionName], table_size(Containers[DirectionName]) + 1, Chest)
					end
				end
			end
		end
	end
	if Debug then log("Returning Containers: " .. serpent.block(Containers)) end
	return Containers
end
return FindContainers