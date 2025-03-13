---Manages Container Upgrades and Downgrades.
---@param Player LuaPlayer
---@param Container LuaEntity
local function ContainerUpgrade(Player, Container)
	local Force = Player.force
	local ForceName = Force.name
	local LinkID = Container.link_id
	local Link = storage.forces[ForceName][Container.name].links[LinkID]
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

				local Surface = Entity.surface
				game.print(
					"\nName (" .. serpent.line(Name) .. "): "  .. type(Name)
					.. "\nPosition (" .. serpent.line(Position) .. "): " .. type(Position)
					.. "\nDirection (" .. serpent.line(Direction) .. "): " .. type(Direction)
					.. "\nQuality (" .. serpent.line(Quality) .. "): " .. type(Quality)
					.. "\nForce (" .. serpent.line(Force) .. "): " .. type(Force)
					--.. "\nTarget (" .. serpent.line(Character) .. "): " .. type(Character)
					--.. "\nSource (" .. serpent.line(Character) .. "): " .. type(Character)
					--.. "\nSnap to Grid (" .. serpent.line(true) .. "): " .. type(true)
					--.. "\nFast Replace (" .. serpent.line(true) .. "): " .. type(true)
					--.. "\nItem Index (" .. serpent.line(0) .. "): " .. type(0)
					--.. "\nPlayer (" .. serpent.line(Player) .. "): " .. type(Player)
					--.. "\nCharacter (" .. serpent.line(Character) .. "): " .. type(Character)
					--.. "\nSpill (" .. serpent.line(true) .. "): " .. type(true)
					--.. "\nRaise Built (" .. serpent.line(true) .. "): " .. type(true)
					--.. "\nCreate Build Effect Smoke (" .. serpent.line(false) .. "): " .. type(false)
					--.. "\nSpawn Decorations (" .. serpent.line(false) .. "): " .. type(false)
					--.. "\nMove Stuck Players (" .. serpent.line(true) .. "): " .. type(true)
					--.. "\nPreserve Ghosts and Corpses (" .. serpent.line(false) .. "): " .. type(false)
					.. "\n", PrintSettings
				)
				local NewEntity = Surface.create_entity{
					name = Name,
					position = Position,
					direction = Direction,
					quality = Quality,
					force = Force,
					--target = Character,
					--source = Character,
					--snap_to_grid = true,
					fast_replace = true,
					item_index = 0,
					player = Player,
					character = Character,
					spill = true,
					--raise_built = true,
					--create_build_effect_smoke = false,
					--spawn_decorations = false,
					--move_stuck_players = true,
					--preserve_ghosts_and_corpses = false
				}
				game.print("Created new Entity: " .. serpent.line(NewEntity), PrintSettings)
				--NewEntity.copy_settings(Entity, Player)

				local Success = Entity.destroy{do_cliff_correction = false, raise_destroy = true, player = Player, item_index = 0}
				game.print("Entity Destroyed: " .. tostring(Success), PrintSettings)
				if Success then
					Link[Counter] = nil
					table.insert(Entities, table_size(Entities) + 1, NewEntity)
				end
			else
				game.print("Invalid Entity " .. serpent.line(Entity))
			end
			if Counter >= Target then
				break
			end
		end
		AssignID(Player, Entities[1], Entities[1].name, Entities, true)
	end
end
return ContainerUpgrade