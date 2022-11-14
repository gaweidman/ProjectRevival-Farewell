-- The 'nice' name of the faction.
FACTION.name = "Droid"
-- A description used in tooltips in various menus.
FACTION.desc = "A common droid."
FACTION.isGloballyRecognized = true
-- A color to distinguish factions from others, used for stuff such as
-- name color in OOC chat.
FACTION.color = Color(222, 183, 29)

FACTION.isDefault = false

FACTION.models = {
	"models/player/valley/k2so.mdl",
	"models/kingpommes/starwars/misc/droids/gnk_droid.mdl",
	"models/kingpommes/starwars/misc/droids/r5_j2.mdl",
	"models/kingpommes/starwars/misc/droids/r2_q5.mdl",
	"models/kingpommes/starwars/misc/droids/r4_i9.mdl",
	"models/starwars/syphadias/ships/probe_droid/probe_droid.mdl",
	"models/kingpommes/starwars/playermodels/mouse.mdl",
}

function FACTION:OnCharacterCreated(client, char)
	char:GiveFlags("D")

	if (char:GetModel() == "models/player/valley/k2so.mdl") then

		char:SetAttrib("str", 20)
		char:SetAttrib("con", 20)
		char:SetAttrib("agi", 2)
		char:SetAttrib("stm", 0) -- TODO: Make it so droids don't use stamina.

		local charset = {}
		for i = 97, 122 do table.insert(charset, string.char(i)) end -- Adds all capital letters to the charset.
		for i = 0, 9 do table.insert(charset, tostring(i)) end -- Adds all numbers 0-9 to the charset.
		
		-- Name setting in the pattern K#-$$, where # is a digit 0-9, and $ is a character 0-9 or A-Z.
		char:SetName("K-"..tostring(math.random(0, 9))..charset[math.random(1, #charset)])

	elseif (char:GetModel() == "models/kingpommes/starwars/misc/droids/r5_j2.mdl") then

		char:SetAttrib("str", 0)
		char:SetAttrib("con", 0)
		char:SetAttrib("agi", 5)
		char:SetAttrib("stm", 0)

		local charset = {}
		for i = 97, 122 do table.insert(charset, string.char(i)) end -- Adds all capital letters to the charset.
		for i = 0, 9 do table.insert(charset, tostring(i)) end -- Adds all numbers 0-9 to the charset.
		
		-- Name setting in the pattern R5-$#, where # is a digit 0-9, and $ is a character A-Z.
		char:SetName("R5-"..charset[math.random(1, #charset)]..tostring(math.random(0, 9)))

	elseif (char:GetModel() == "models/kingpommes/starwars/misc/droids/r2_q5.mdl") then

		char:SetAttrib("str", 0)
		char:SetAttrib("con", 0)
		char:SetAttrib("agi", 5)
		char:SetAttrib("stm", 0)

		local charset = {}
		for i = 97, 122 do table.insert(charset, string.char(i)) end -- Adds all capital letters to the charset.
		
		-- Name setting in the pattern R2-$#, where # is a digit 0-9, and $ is a character A-Z.
		char:SetName("R2-"..charset[math.random(1, #charset)]..tostring(math.random(0, 9)))
	elseif (char:GetModel() == "models/kingpommes/starwars/misc/droids/r4_i9.mdl") then

		char:SetAttrib("str", 0)
		char:SetAttrib("con", 0)
		char:SetAttrib("agi", 5)
		char:SetAttrib("stm", 0)

		local charset = {}
		for i = 97, 122 do table.insert(charset, string.char(i)) end -- Adds all capital letters to the charset.
		
		-- Name setting in the pattern R4-$#, where # is a digit 0-9, and $ is a character A-Z.
		char:SetName("R4-"..charset[math.random(1, #charset)]..tostring(math.random(0, 9)))
	elseif (char:GetModel() == "models/kingpommes/starwars/playermodels/mouse.mdl") then

		char:SetAttrib("str", 0)
		char:SetAttrib("con", 0) -- TODO: Make it so mouse droids have 5 health.
		char:SetAttrib("agi", 15)
		char:SetAttrib("stm", 0)

		local charset = {}
		for i = 97, 122 do table.insert(charset, string.char(i)) end -- Adds all capital letters to the charset.
		
		-- Name setting in the pattern MSE-6-$###$, where # is a digit 0-9, and $ is a character A-Z.
		char:SetName("MSE-6-"..charset[math.random(1, #charset)]..tostring(math.random(111, 999))..charset[math.random(1, #charset)])

	elseif (char:GetModel() == "models/kingpommes/starwars/misc/droids/gnk_droid.mdl") then

		char:SetAttrib("str", 0)
		char:SetAttrib("con", 0) -- TODO: Make it so gonk droids have 10 health.
		char:SetAttrib("agi", 0) -- TODO: Make it so gonk droids move painfully slow.
		char:SetAttrib("stm", 0) -- TODO: Make it so gonk droids can't run.

		local charset = {}
		for i = 97, 122 do table.insert(charset, string.char(i)) end -- Adds all capital letters to the charset.
		
		local charset2 = {}
		for i = 97, 122 do table.insert(charset2, string.char(i)) end -- Adds all capital letters to the charset.
		for i = 0, 9 do table.insert(charset2, tostring(i)) end -- Adds all numbers 0-9 to the charset.

		-- Name setting in the pattern GNK-### where # is a digit 0-9.
		char:SetName("X"..charset[math.random(1, #charset)]..tostring(math.random(0, 9)).."-"..charset2[math.random(1, #charset2)]..charset2[math.random(1, #charset2)]..charset2[math.random(1, #charset2)]..charset2[math.random(1, #charset2)])

	end
end

-- FACTION.index is defined when the faction is registered and is just a numeric ID.
-- Here, we create a global variable for easier reference to the ID.
FACTION_DROID = FACTION.index
