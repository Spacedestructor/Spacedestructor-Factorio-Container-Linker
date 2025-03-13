local function DecodeBlueprint(Blueprintstring)
	return helpers.decode_string(Blueprintstring)
end

local function EncodeBlueprint(Table)
	return helpers.encode_string(Table)
end

return DecodeBlueprint, EncodeBlueprint