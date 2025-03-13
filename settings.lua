data:extend({--Used to Determine how Containers merge and what Container Prototypes to generate.
	--Prototype Name of the LinkedContainerPrototype to use for the Linked Container Template.
	{
		setting_type = "startup",
		type = "string-setting",
		name = "Spacedestructor-LinkedTemplate",
		order = "1",
		hidden = false,
		default_value = "linked-chest",
		allow_blank = false,
		auto_trim = true
	},--Used to defined the type of Entity that should be used to copy the prototype sprite.
	{
		setting_type = "startup",
		type = "string-setting",
		name = "Spacedestructor-ContainerType",
		order = "2",
		hidden = false,
		default_value = "container",
		allowed_values = { "container", "logistic-container", "infinity-container", "temporary-container", "linked-container", "proxy-container"}
	},--Prototype Name to use for the Linked Container Sprite.
	{
		setting_type = "startup",
		type = "string-setting",
		name = "Spacedestructor-LinkedSprite",
		order = "3",
		hidden = false,
		default_value = "steel-chest",
		allow_blank = false,
		auto_trim = true
	},--Defines the Chests Inventory Size.
	{
		setting_type = "startup",
		type = "int-setting",
		name = "Spacedestructor-InventorySlots",
		order = "4",
		hidden = false,
		default_value = 30,
		minimum_value = 1,
		maximum_value = 900720000000000/50
	},--Defines the limit how many Upgrades a Player can recieve to there Linked Containers. Limit is hard to define as it shares the common prototype limit with other Entities.
	{
		setting_type = "startup",
		type = "int-setting",
		name = "Spacedestructor-TierLimit",
		order = "5",
		hidden = false,
		default_value = 6,
		minimum_value = 1,
		maximum_value = 50
	}
})