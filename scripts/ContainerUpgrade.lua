---Manages Container Upgrades.
---@param Player LuaPlayer
---@param Container LuaEntity
local function ContainerUpgrade(Player, Container)
	assert(Player ~= nil and Player.object_name == "LuaPlayer" and Player.valid == true, "Player " .. serpent.line(Player) .. " is not a valid Player.")
	if Debug then log("Parameter Player: " .. serpent.line(Player)) end

	assert(Container ~= nil and Container.object_name == "LuaEntity" and Container.valid == true, "Container " .. serpent.line(Container) .. " is not a valid Entity.")
	if Debug then log("Parameter Container: " .. serpent.line(Container)) end

	local Force = Player.force
	---@diagnostic disable-next-line: param-type-mismatch
	assert(Force ~= nil and Force.valid == true and Force.object_name == "LuaForce", "Force " .. serpent.line(Force) .. " is not a valid Force.")
	if Debug then log("Force: " .. serpent.line(Force)) end

	local ForceName = Force.name
	assert(ForceName ~= nil and type(ForceName) == "string" and game.forces[ForceName].valid, "ForceName " .. serpent.line(ForceName) .. "is not a valid Force Name.")
	if Debug then log("Force Name: " .. serpent.line(ForceName)) end

	local LinkID = Container.link_id
	assert(LinkID ~= nil and type(LinkID) == "number" and LinkID > 0, "LinkID " .. serpent.line(LinkID) .. " is not a valid link_id.")
	if Debug then log("Link ID " .. serpent.line(LinkID) .. " from Container " .. serpent.line(Container)) end

	local Link = storage.forces[ForceName][Container.name].links[tostring(LinkID)]
 	assert(Link ~= nil and type(Link) == "table" and table_size(Link) > 1, "Link " .. serpent.block(Link) .. "\nis not a valid table.")
	if Debug then log("Link: " .. serpent.block(Link)) end

	local Tier = tonumber(string.sub(Container.name, 43, string.len(Container.name)))
	assert(Tier ~= nil and type(Tier) == "number" and Tier > 0, "Tier " .. serpent.line(Tier) .. " is not a Valid Tier.")
	if Debug then log("Tier: " .. serpent.line(Tier)) end

	local Target = math.min(table_size(Link), tonumber(settings.startup["Spacedestructor-TierLimit"].value))
	assert(Target ~= nil and type(Target) == "number" and Target > Tier, "Target " .. serpent.line(Target) .. " is not a valid Target.")
	if Debug then log("Target: " .. serpent.line(Target)) end

	if Tier < Target then
		local Entities = {}
		--Note: pairs and ipairs crashes c++ because it doesnt like it when i actively remove from the table it itterates over.
		--Why does a while loop work but not a for loop?
		--Returning to for loop but limiting it to 50, this should also prevent infinite loops.

		local LinkSize = table_size(Link)
		local Counter = 0
		for i = 1, LinkSize, 1 do
			Counter = Counter + 1
			local Entity = Link[Counter]
			assert(Entity ~= nil and Entity.valid == true and Entity.object_name == "LuaEntity", "Entity " .. serpent.line(Entity) .. " is not a Valid Entity.")
			if Debug then log("Entity: " .. serpent.line(Entity)) end

			local Name = prototypes.entity["Spacedestructor-linked-container-2x2-Tier-" .. Target]
			assert(Name ~= nil and Name.valid == true and Name.object_name == "LuaEntityPrototype", "Name " .. serpent.line(Name) .. " is not a Valid Entity Prototype.")
			if Debug then log("Name: " .. serpent.line(Name)) end

			local Position = Entity.position
			assert(Position ~= nil and type(Position) == "table" and (type(Position[1]) == "number" or type(Position.x) == "number") and (type(Position[2]) == "number" or type(Position.y) == "number"), 'Position is "' .. serpent.line(Position) .. '(' .. type(Position) .. ', Valid: ' .. tostring((type(Position[1]) == "number" or type(Position.x) == "number") and (type(Position[2]) == "number" or type(Position.y) == "number")) .. ')".')
			if Debug then log("Position: " .. serpent.line(Position)) end

			local Direction = defines.direction.north
			--Not entirely sure how to validate defines, they are a mystery to me.
			assert(Direction ~= nil)
			if Debug then log("Direction: " .. serpent.line(Direction)) end

			local Quality = Entity.quality
			assert(Quality ~= nil and Quality.valid == true and Quality.object_name == "LuaQualityPrototype", "Quality " .. serpent.line(Quality) .. " is not a valid Quality.")
			if Debug then log("Quality: " .. serpent.line(Quality)) end

			local Character = Player.character or Player.cutscene_character
			assert(Character ~= nil and Character.valid == true and Character.object_name == "LuaEntity", "Character " .. serpent.line(Character) .. " is not a Valid Character.")
			if Debug then log("Character: " .. serpent.line(Character)) end

			local Surface = Entity.surface
			assert(Surface ~= nil and Surface.valid and Surface.object_name == "LuaSurface", "Surface " .. serpent.line(Surface) .. " is not a Valid Surface.")
			if Debug then log("Surface: " .. serpent.line(Surface)) end

			local NewEntity = Surface.create_entity{name = Name, position = Position, direction = Direction, quality = Quality, force= Force, fast_replace = false, item_index = 0, player = Player, character = Character, spill = true, raise_built = false, create_build_effect_smoke = false, spawn_decorations = false, move_stuck_players = true, preserve_ghosts_and_corpses = false, bar = Entity.get_inventory(defines.inventory.chest).get_bar()}
			assert(NewEntity ~= nil and NewEntity.valid and NewEntity.object_name == "LuaEntity", "NewEntity " .. serpent.line(NewEntity) .. " is not a Valid Entity.")
			if Debug then log("New Entity: " .. serpent.line(NewEntity)) end

			NewEntity.copy_settings(Entity, Player)

			local Success = Entity.destroy{do_cliff_correction = false, raise_destroy = false, player = Player, item_index = 0}
			assert(Success, "We cant continue without destroying " .. serpent.line(Entity) .. " first!")
			if Debug then log("Entity Destroyed: " .. tostring(Success)) end

			Link[tostring(Counter)] = nil
			table.insert(Entities, table_size(Entities) + 1, NewEntity)
			if Debug then log("Links: " .. serpent.block(storage.forces[ForceName])) end

			if table_size(Link) == 0 then Link = nil end
			if Counter >= Target then break end
		end
		Clean(ForceName, Tier, LinkID)
		_ = AssignID(Player, Entities)
	end
end
return ContainerUpgrade