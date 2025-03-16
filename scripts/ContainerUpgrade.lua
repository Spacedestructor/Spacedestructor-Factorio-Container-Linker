---Manages Container Upgrades and Downgrades.
---@param Player LuaPlayer
---@param Container LuaEntity
local function ContainerUpgrade(Player, Container)
	local Force = Player.force
	local ForceName = Force.name
	if Debug then log("Force Name: " .. serpent.line(ForceName))
	end
	local LinkID = Container.link_id
	if Debug then log("Link ID: " .. serpent.line(LinkID)); log("Container Name: " .. serpent.line(Container.name)) end
	local Link = storage.forces[ForceName][Container.name].links[LinkID]
	if Debug then log("Link: " .. serpent.block(Link)) end
 	assert(type(Link) == "table", "Link must be type table but is actually " .. type(Link))
	local Tier = tonumber(string.sub(Container.name, 43, string.len(Container.name)))
	local Target = math.min(table_size(Link), tonumber(settings.startup["Spacedestructor-TierLimit"].value))
	if Target ~= Tier then
		local Entities = {}
		--Note: pairs and ipairs crashes c++ because it doesnt like it when i actively remove from the table it itterates over.
		--Why does a while loop work but not a for loop?

		local Counter = 0
		while true do
			Counter = Counter + 1
			local Entity = Link[Counter]
			if Entity.valid then
				local Name = "Spacedestructor-linked-container-2x2-Tier-" .. Target
				local Position = Entity.position
				local Direction = defines.direction.north
				local Quality = Entity.quality.name
				local Character = Player.character
				assert(Character ~= nil and Character.object_name == "LuaEntity", 'Character cant be "nil" and must be of type "LuaEntity".')
				local Surface = Entity.surface
				if Debug then
					log(
						"\nName (" .. serpent.line(Name) .. "): "  .. type(Name) ..
						"\nPosition (" .. serpent.line(Position) .. "): " .. type(Position) ..
						"\nDirection (" .. serpent.line(Direction) .. "): " .. type(Direction) ..
						"\nQuality (" .. serpent.line(Quality) .. "): " .. type(Quality) ..
						"\nForce (" .. serpent.line(ForceName) .. "): " .. type(ForceName) ..
						"\nFast Replace (" .. serpent.line(true) .. "): " .. type(true) ..
						"\nItem Index (" .. serpent.line(0) .. "): " .. type(0) ..
						"\nPlayer (" .. serpent.line(Player.name) .. "): " .. type(Player.name) ..
						"\nCharacter (" .. serpent.line(Character) .. "): " .. Character.object_name ..
						"\nSpill (" .. serpent.line(true) .. "): " .. type(true) ..
						"\nRaise Built (" .. serpent.line(true) .. "): " .. type(true) ..
						"\nCreate Build Effect Smoke (" .. serpent.line(false) .. "): " .. type(false) ..
						"\nSpawn Decorations (" .. serpent.line(false) .. "): " .. type(false) ..
						"\nMove Stuck Players (" .. serpent.line(true) .. "): " .. type(true) ..
						"\nPreserve Ghosts and Corpses (" .. serpent.line(false) .. "): " .. type(false) ..
						"\nBar (" .. serpent.line(Entity.get_inventory(defines.inventory.chest).get_bar()) .. "): " .. type(Entity.get_inventory(defines.inventory.chest).get_bar())
					)
				end
				local NewEntity = Surface.create_entity{
					name = Name,
					position = Position,
					direction = Direction,
					quality = Quality,
					force= Force,
					fast_replace = true,
					item_index = 0,
					player = Player,
					character = Character,
					spill = true,
					raise_built = true,
					create_build_effect_smoke = false,
					spawn_decorations = false,
					move_stuck_players = true,
					preserve_ghosts_and_corpses = false,
					bar = Entity.get_inventory(defines.inventory.chest).get_bar()
				}
				if Debug then log("Created new Entity: " .. serpent.line(NewEntity)) end
				--[[
				NewEntity.copy_settings(Entity, Player)

				local Success = Entity.destroy{do_cliff_correction = false, raise_destroy = true, player = Player, item_index = 0}
				if Debug then
					log("Entity Destroyed: " .. tostring(Success))
				end
				if Success then
					]]
					Link[Counter] = nil
					table.insert(Entities, table_size(Entities) + 1, NewEntity)
					--[[
				end
				]]
			else
				if Debug then log("Invalid Entity " .. serpent.line(Entity)) end
			end
			if Counter >= Target then
				break
			end
		end
		_ = AssignID(Player, Entities[1], Entities, true)
	end
end
return ContainerUpgrade