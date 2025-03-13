local function BlueprintTest()
--[[
	local String = "0eNqtmG2PmzAMx79LXocTeQT6VU5VRdvsFI0GBGFbV/W7L7TaTr2SOyfeq6YU/MN2/nbqC9l3sxlG6zzZXIg99G4im9cLmeyba7vlmmtPhmyIH1vriq5vj2YkV0qsO5pfZMOuW0qM89Zbc3/y9uW8c/NpH+7cMPrXwrd28kUw46ahH32xN50nlAz9FJ7t3YIK9gqm6hdFyTksefmiAuloR3O43yKv9AnAkwHVPwCDAAQCsHiwYlImm9TxoDC+QlCPhDlka3wb+/AJYTzHhRJ/HhZz1g2zJytEnewTT0t0lQwQaYAa4QFoJzUZSRGQpPSzj2SFlclOlWlRY+kKZ3FCvUbgCB8YiCAQPoBSz2R+HWTNehVhCmGzjth8l/HJHO18KkwX/BrtoRj6znxe7qIv+kG61k1m9OGXT6vQzdpj6ijpf5hxtEezm3x7+L6b7G+zNKEVZp3ArB7C8lFkcGaTHjz+VfB4meCI+D/B4yyByePBW5QLh/J8Eca2Mxf5pSOaEIl4zwZ0pMEIW0MKHtcIQhWJS5WlOI1RHM9TeYViNlniqFDiEGUWVOOgiNYe2yUCo3LQ3hYCsbcliIBp5gpEUJg2LCOh11lt+B4S+KbJKwMKI0lRYxpvLFxNVuNNDJfME7ZCCVsyRFsESURiZC4hTVIizuwwEUqMzAXIB5U/W2AcRNAIggBFqcofZjwTVocZssZMM1YC9fU0Qzb50wZY7lWZP24AEhiCANpdimMmGp8lJj7RUJgjPV8v9UoibMJyoRDVSkTeWiNsruR3S8nP8H0Z474yTRUN/2fVlt7X4URyWzfLur6tl0v3dXjSenMKL/I+TqYkdKPpZlpp3simUUqxWmp5vf4ByEhFiw=="

	String = string.sub(String, 2, -1)

	local Blueprint = helpers.json_to_table(DecodeBlueprint(String)).blueprint

	assert(Blueprint)

	if Debug then
		log("Blueprint: " .. serpent.block(Blueprint))
		game.print("Blueprint: " .. serpent.line(Blueprint))
	end

	local Icons = Blueprint.icons

	if Debug then
		log("Icons: " .. serpent.block(Icons))
		game.print("Icons: " .. serpent.line(Icons))
	end

	local Entities = Blueprint.entities

	if Debug then
		log("Entities: " .. serpent.block(Entities))
		game.print("Entities: " .. serpent.line(Entities))
	end

	local Wires = Blueprint.wires

	if Debug then
		log("Wires: " .. serpent.block(Wires))
		game.print("Wires: " .. serpent.line(Wires))
	end

	local Entity = game.players[1].surface.find_entities_filtered{position = game.players[1].position, radius = 10, type = "linked-container"}

	if Debug then
		log("Entity: " .. serpent.block(Entity))
		game.print("Entity: " .. serpent.line(Entity))]]
		--[[
		for index, entity in pairs(Entity) do
			for variable, data in pairs(entity) do
				if type(data) ~= "function" and type(data) ~= "table" and type(data) ~= "userdata" then
					log("variable: " .. serpent.block(variable))
					game.print("variable: " .. serpent.line(variable))
				end
			end
		end
		]]
	--end

	--error("Debug End.", 1)
end

--script.on_event(defines.events)

return BlueprintTest