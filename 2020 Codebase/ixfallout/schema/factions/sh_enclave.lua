FACTION.name = "Enclave"
FACTION.description = "factionEnclaveDesc"
FACTION.color = Color(93, 93, 93)
FACTION.isDefault = false
FACTION.pay = 10

FACTION.models = {
	"models/player/neutral/hub/wastelander1_female_01.mdl",
	"models/player/neutral/hub/wastelander1_female_04.mdl",
	"models/player/neutral/hub/wastelander1_female_07.mdl",
	"models/player/neutral/hub/wastelander1_female_ghoul.mdl",
	"models/player/neutral/hub/wastelander1_male_01.mdl",
	"models/player/neutral/hub/wastelander1_male_05.mdl",
	"models/player/neutral/hub/wastelander1_male_09.mdl",
	"models/player/neutral/hub/wastelander1_male_ghoul.mdl",
	"models/player/neutral/hub/wastelander2_female_01.mdl",
	"models/player/neutral/hub/wastelander2_female_04.mdl",
	"models/player/neutral/hub/wastelander2_female_07.mdl",
	"models/player/neutral/hub/wastelander2_female_ghoul.mdl",
	"models/player/neutral/hub/wastelander2_male_01.mdl",
	"models/player/neutral/hub/wastelander2_male_05.mdl",
	"models/player/neutral/hub/wastelander2_male_09.mdl",
	"models/player/neutral/hub/wastelander2_male_ghoul.mdl",
	"models/player/neutral/hub/wastelander3_female_01.mdl",
	"models/player/neutral/hub/wastelander3_female_04.mdl",
	"models/player/neutral/hub/wastelander3_female_07.mdl",
	"models/player/neutral/hub/wastelander3_female_ghoul.mdl",
	"models/player/neutral/hub/wastelander3_male_01.mdl",
	"models/player/neutral/hub/wastelander3_male_05.mdl",
	"models/player/neutral/hub/wastelander3_male_09.mdl",
	"models/player/neutral/hub/wastelander3_male_ghoul.mdl"
}

function FACTION:OnCharacterCreated(client, character)
	inventory:Add("laserrifle", 1)
	inventory:Add("microfusioncell", 3)
	inventory:Add("enclave_combat_armor", 1)
	inventory:Add("water", 1)
	inventory:Add("cram", 1)
end

FACTION_ENCLAVE = FACTION.index