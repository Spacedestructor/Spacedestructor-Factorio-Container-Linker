--For Debugging Purposes.

Debug = false
if script.active_mods["gvv"] then require("__gvv__.gvv")(); Debug = true end
if script.active_mods["0-event-trace"] then Debug = true end

if __DebugAdapter ~= nil then Debug = true end
log("Debug Mode: " .. tostring(Debug))

--[[
	Requirements:
	1) Chests are 2x2; scaled up appearance from steel chests and logistic chests
	2) Chests DO NOT snap to 2x2 grid like rails, allowing flexibility of placement for if people want to use inserters or loaders when interacting with cargo wagons
	3) Chests have 30(maybe configurable?) slots
	4) When chests are combined, storage size increases (n * 30(maybe configurable?)) - Inspired by Space Age's cargo thingy.  Removing a chest will shrink the storage size
	5) Chests must fully share a side in order to combine (much like nuclear reactors)
	6) Chests automatically link with their full-contact neighbor similar to https://mods.factorio.com/mod/SchallAutolinkedChest
	7) Circuit connections should still work
	8) No user-configurable link_id
	9) Can pull from and insert into using inserters and/or loaders

	Extras:
		Linked Chest and Logistics Chest as Seperate Branches.

	Clarifications:
		For #4: This means Chest Inventory Size multiplied by the Number of Chests linked together, not actual inventory Size.
			Due to this, we dont actually do anything else then linked chests as they are the only ones capable of making use of the mods functionality.

	Notes:
	For #1: I just need to take the sprites from steel chest for non logistic variant and the logistic chest for the logsitic variant.
	For #2: I dont need to do anything, this is already vanilla placement behaviour for chests.
	For #3: I need clarification how it would be customizable. could make my chests inventory depend on there size and give it a setting for slots per tile.
	For #4: Similarly as for #3, only difference is we add the inventory sizes of each chest together. also how does the merging work?
	For #5: Touching sides is easy to ensure by reading position and size of each chest.
	For #6: Do we actually need linking if they merge?
	For #7: Circuit connection should be unaffected by merging or linking, other then maybe resetting it unintentionally.
	For #8: No User facing Link ID option, so i have to figure out by what logic they Link.
	For #9: With using Chest Entities this should work by default.
	For info.json: add "(?)" for gvv and 0-event-trace before uploading, to make them hidden optional dependencies.

	Search Term: "merg"
	Example 1: https://mods.factorio.com/mod/WideChests (less ideal, complex and difficult to understand structure)
	Example 2: https://mods.factorio.com/mod/LB-Modular-Chests (better alternative to Example 1, looks to be a lot easier to understand.)

	When Chests link together check how many use the same ID and how many touch each other in a horizontal or vertical row.
	Replace the Chests with the Tier version equal to the number of chests with the same ID and in the same row.
	The Setting "Spacedestructor-TierLimit" defines the limit how high these upgrades can go.
	if for example 2 train stops share the same ID will they not contribute to upgrade each others Container Tier unless they are directly touching each other and even if will they never exeed the defined Tier limit.
	the mod will dynamically generate Linked Container Prototypes for the defined Tier Limit and each Tiers inventory capacity will be the number defined in the Setting "Spacedestructor-InventorySlots" multiplied by the number which tier it is.
	Ex: Setting set to 30 (default value) and tier limit set to 6 (default value) the progression will be the following: 30, 60, 90, 120, 150, 180.
]]

PrintSettings = {color = {r = 255, g = 255, b = 255, a = 255}, sound = defines.print_sound.never, skip = defines.print_skip.never, game_state = false}
local StartingItem = {
	{name = "Spacedestructor-linked-container-2x2-Tier-1", count = 6},
	{name = "Spacedestructor-linked-container-2x2-Tier-2", count = 6},
	{name = "Spacedestructor-linked-container-2x2-Tier-3", count = 6},
	{name = "Spacedestructor-linked-container-2x2-Tier-4", count = 6},
	{name = "Spacedestructor-linked-container-2x2-Tier-5", count = 6},
	{name = "Spacedestructor-linked-container-2x2-Tier-6", count = 6},
	{name = "infinity-chest", count = 2},
	{name = "fast-inserter", count = 2},
	{name = "substation", count = 1},
	{name = "electric-energy-interface", count = 1}
}
local function InsertStartingItems()
	local Player = game.players["Spacedestructor"]
	Player.cheat_mode = true
	local Character = Player.character
	if Character then
		local Inventory = Player.get_main_inventory()
		if Inventory ~= nil then
			local Slot = 1
			for _, value in pairs(StartingItem) do
				if value ~= nil and value.name ~= nil and value.count ~= nil then
					if Inventory.can_insert(value) then
						Inventory.insert(value)
						local ItemStack = Inventory.find_item_stack(value.name)
						Player.set_quick_bar_slot(Slot, ItemStack)
					end
					Slot = Slot + 1
				else
					error('Entry "' .. serpent.block(value) .. '" is invalid!')
				end
			end
			script.on_event(defines.events.on_tick, nil)
		end
	end
end

local function DelayedStartingItems(Event)
	if Event.tick > 0 then
		InsertStartingItems()
	end
end

local function StartingItems(Event)
	local Player = game.players[Event.player_index]
	if Player.name == "Spacedestructor" then
		if Event.tick < 1 then
			script.on_event(defines.events.on_tick, DelayedStartingItems)
		else
			InsertStartingItems()
		end
	end
end

script.on_event(defines.events.on_player_created, StartingItems)

local FindContainers = require("scripts.FindContainers")
local ManageID = require("scripts.ManageID")

PrintSettings = { color = { r = 255, g = 255, b = 255, a = 255 }, sound = defines.print_sound.never, skip = defines.print_skip.never, game_state = false }
StartingItems = require("scripts.Debug")

script.on_event(defines.events.on_player_created, StartingItems)

--Finds all Containers on the same X or Y axis and lists them in to Containers = { top = {Entity}, right = {Entity}, bottom = {Entity}, left = {Entity}}
FindContainers = require("scripts.FindContainers")
--Takes a Table of Tables such as the one produced by "FindContainers" to find the largest Sub Table and Returns the Name of it as a String or nil if all Sides are empty.

FindLargestSizeBiased = require("__Spacedestructor-Library__.scripts.Level_1.FindLargestSizeBiased")
AssignID = require("scripts.AssignID")
ContainerUpgrade = require("scripts.ContainerUpgrade")

local function OnBuilt(Event)
	local Entity = Event.entity
	if string.sub(Entity.name, 1, 36) == "Spacedestructor-linked-container-2x2" then
		ManageID(Event.player_index, FindContainers(Entity), Entity)
	end
end

DefinesLookup = require("__Spacedestructor-Library__.scripts.Level_2.DefinesLookup")
Clean = require("scripts.Clean")

OnBuilt = require("scripts.OnBuilt")

script.on_event(defines.events.on_built_entity, OnBuilt)
script.on_event(defines.events.on_robot_built_entity, OnBuilt)
script.on_event(defines.events.on_space_platform_built_entity, OnBuilt)
script.on_event(defines.events.script_raised_revive, OnBuilt)
script.on_event(defines.events.script_raised_built, OnBuilt)

local function OnMined(Event)
	--ContainerUpgrade(game.players[Event.player_index], Event.entity)
end

Downgrade = require("scripts.ContainerDowngrade")

OnMined = require("scripts.OnMined")

script.on_event(defines.events.on_player_mined_entity, OnMined)
script.on_event(defines.events.on_robot_mined_entity, OnMined)

local function OnDied(Event)
end

OnDied = require("scripts.OnDied")

script.on_event(defines.events.on_entity_died, OnDied)

Init = require("scripts.Init")

--New Game

script.on_init(Init)

--Loaded Game

script.on_load(Init)
