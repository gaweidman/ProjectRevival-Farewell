FACTION.name = "Wastelander"
FACTION.description = "factionWastelanderDesc"
FACTION.color = Color(0, 140, 0)
FACTION.isDefault = true
FACTION.pay = 6

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
	local inventory = character:GetInventory()
	
	inventory:Add("sunsetsarsaparilla", 2)
	inventory:Add("bandage", 1)

	if character:GetAttribute("luck", 0) then
		local luck = character:GetAttribute("luck", 0)
		local luckMult = ix.config.Get("luckMultiplier", 1)

		if (luck * luckMult < 1) then
			inventory:Add("22rifle", 1)
			inventory:Add("22lr", 2)
			inventory:Add("steak", 1)
			inventory:Add("cigarettepack", 1)
			character:GiveMoney(6)
		elseif (luck * luckMult < 3) then
			inventory:Add("singleshotgun", 1)
			inventory:Add("20gauge", 2)
			inventory:Add("dirtywater", 1)
			inventory:Add("steak", 1)
			character:GiveMoney(10)
		elseif (luck * luckMult < 20) then
			inventory:Add("10mmpistol", 1)
			inventory:Add("10mm", 2)
			inventory:Add("brahminsteak", 1)
			inventory:Add("nukacola", 1)
			inventory:Add("money", 1)
			character:GiveMoney(15)
		else
			inventory:Add("laserpistol", 1)
			inventory:Add("energycell", 2)
			inventory:Add("cram", 1)
			inventory:Add("water", 1)
			character:GiveMoney(30)
		end
	else
		inventory:Add("22rifle", 1)
		inventory:Add("22lr", 2)
		inventory:Add("geckosteak", 1)
		inventory:Add("cigarettepack", 1)
		character:GiveMoney(10)
	end
end

FACTION_WASTELANDER = FACTION.index