local Deepcopy = require("util").table.deepcopy
local Prototypes = {}
---Finds the Properties of a Sprite in the Layers of Entity.Picture.
---@param Layers table
---@param Width number
---@param Height number
local function FindSpriteProperties(Layers, Width, Height)
	assert(Layers ~= nil and Width ~= nil and Height ~= nil, "Missing Layer, Width or Height!")
	if  Layers.width ~= nil or Layers.height ~= nil or Layers.scale ~= nil then
		Layers.scale = 1
	elseif Layers.layers ~= nil then
		FindSpriteProperties(Layers.layers, Width, Height)
	elseif type(Layers[1]) == "table" then
		for _, value in pairs(Layers) do
			FindSpriteProperties(value, Width, Height)
		end
	else
		log("Whats this? " .. serpent.block(Layers))
	end
end

---Generates Prototypes.
local function GeneratePrototypes()
	local Tiers = settings.startup["Spacedestructor-TierLimit"].value
	for i = 1, Tiers, 1 do
		local Item = Deepcopy(data.raw["item"][settings.startup["Spacedestructor-LinkedTemplate"].value])
		Item.name = "Spacedestructor-linked-container-2x2-Tier-" .. i
		Item.icon = data.raw["item"][settings.startup["Spacedestructor-LinkedSprite"].value].icon
		Item.place_result = "Spacedestructor-linked-container-2x2-Tier-" .. i
		Item.hidden = false
		table.insert(Prototypes, table_size(Prototypes) + 1, Item)

		local Chest = Deepcopy(data.raw["linked-container"][settings.startup["Spacedestructor-LinkedTemplate"].value])
		Chest.name = "Spacedestructor-linked-container-2x2-Tier-" .. i
		Chest.collision_box = {{-0.9, -0.9},{0.9, 0.9}}
		Chest.selection_box = {{-0.9, -0.9},{0.9, 0.9}}
		Chest.picture = data.raw[settings.startup["Spacedestructor-ContainerType"].value][settings.startup["Spacedestructor-LinkedSprite"].value].picture
		Chest.inventory_size =  settings.startup["Spacedestructor-InventorySlots"].value * i
		Chest.minable.result = "Spacedestructor-linked-container-2x2-Tier-1"
		Chest.hidden = false
		Chest.gui_mode = "none"
		if i < Tiers then
			Chest.next_upgrade = "Spacedestructor-linked-container-2x2-Tier-" .. (i + 1)
		end
		--If we had Containers of different sizes this would allow us the ability to dynamically adjust the Sprites of these Containers, however as of right now this function is entirely unused.
		--EDIT: Apparently i still need it to scale the Sprites to the right size, ooops.

		FindSpriteProperties(Chest.picture, 2, 2)
		table.insert(Prototypes, table_size(Prototypes) + 1, Chest)
	end
	local Recipe = {
		type = "recipe",
		name = "Spacedestructor-linked-container-2x2-Tier-1",
		enabled = true,
		ingredients = {
			{
				type = "item",
				name = "steel-chest",
				amount = 5
			},
			{
				type = "item",
				name = "electronic-circuit",
				amount = 5
			},
			{
				type = "item",
				name = "electronic-circuit",
				amount = 5
			}
		},
		results = {
			{
				type = "item",
				name = "Spacedestructor-linked-container-2x2-Tier-1",
				amount = 1
			}
		}
	}
	table.insert(Prototypes, table_size(Prototypes) + 1, Recipe)
	--log("#" .. table_size(Prototypes) .. " Prototypes to Register: " .. serpent.block(Prototypes))

	data:extend(Prototypes)
end
GeneratePrototypes()