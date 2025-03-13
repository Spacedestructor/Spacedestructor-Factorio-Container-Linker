--[[
actually no, we dont do this content based. just assing the first free ID when a new group forms.

local Items = data.raw["item"]
local LinkID = 0
log("Default Link ID: " .. LinkID)
for _, Item0 in pairs(Items) do
	LinkID = LinkID + 1
	log('Link ID: ' .. LinkID .. ' for Item 0: "' .. Item0.name .. '"')
	if LinkID == 4294967295 then error("Link ID limit reached!", 1) end
end
for _, Item1 in pairs(Items) do
	for _, Item2 in pairs(Items) do
		LinkID = LinkID + 1
		log('Link ID: ' .. LinkID .. ' for Item 1: "' .. Item1.name .. '" and Item 2: "' .. Item2.name .. '"')
		if LinkID == 4294967295 then error("Link ID limit reached!", 1) end
	end
end
error("Debug End.", 1)
]]