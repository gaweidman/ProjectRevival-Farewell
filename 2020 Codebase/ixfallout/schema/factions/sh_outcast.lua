FACTION.name = "Brotherhood Outcast"
FACTION.description = "factionOutcastDesc"
FACTION.color = Color(105, 105, 105)
FACTION.isDefault = false
FACTION.pay = 5

FACTION.models = {
	"models/player/neutral/hub/wastelander1_female_01.mdl",
	"models/player/neutral/hub/wastelander1_female_04.mdl",
	"models/player/neutral/hub/wastelander1_female_07.mdl",
	"models/player/neutral/hub/wastelander1_male_01.mdl",
	"models/player/neutral/hub/wastelander1_male_05.mdl",
	"models/player/neutral/hub/wastelander1_male_09.mdl",
	"models/player/neutral/hub/wastelander2_female_01.mdl",
	"models/player/neutral/hub/wastelander2_female_04.mdl",
	"models/player/neutral/hub/wastelander2_female_07.mdl",
	"models/player/neutral/hub/wastelander2_male_01.mdl",
	"models/player/neutral/hub/wastelander2_male_05.mdl",
	"models/player/neutral/hub/wastelander2_male_09.mdl",
	"models/player/neutral/hub/wastelander3_female_01.mdl",
	"models/player/neutral/hub/wastelander3_female_04.mdl",
	"models/player/neutral/hub/wastelander3_female_07.mdl",
	"models/player/neutral/hub/wastelander3_male_01.mdl",
	"models/player/neutral/hub/wastelander3_male_05.mdl",
	"models/player/neutral/hub/wastelander3_male_09.mdl"
}

function FACTION:OnCharacterCreated(client, character)
	local id = Schema:ZeroNumber(math.random(1, 99999), 5)
	local inventory = character:GetInventory()

	character:SetData("bosholotag", id)

	inventory:Add("laserrifle", 1)
	inventory:Add("microfusioncell", 3)
	inventory:Add("bos_combat_armor", 1)
	inventory:Add("water", 1)
	inventory:Add("cram", 1)
	inventory:Add("bosholotag", 1, {
		name = character:GetName(),
		id = id
	})
end

FACTION_OUTCAST = FACTION.index