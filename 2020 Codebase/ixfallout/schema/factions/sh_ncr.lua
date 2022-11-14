FACTION.name = "New California Republic"
FACTION.description = "factionNCRDesc"
FACTION.color = Color(205, 133, 63)
FACTION.isDefault = false
FACTION.pay = 7

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
	local id = Schema:ZeroNumber(math.random(1, 99999), 5)
	local inventory = character:GetInventory()

	character:SetData("ncrdogtag", id)

	inventory:Add("servicerifle", 1)
	inventory:Add("556mm", 3)
	inventory:Add("ncr_armor", 1)
	inventory:Add("sunsetsarsaparilla", 1)
	inventory:Add("cram", 1)
	inventory:Add("ncrdogtag", 1, {
		name = character:GetName(),
		id = id
	})
end

FACTION_NCR = FACTION.index