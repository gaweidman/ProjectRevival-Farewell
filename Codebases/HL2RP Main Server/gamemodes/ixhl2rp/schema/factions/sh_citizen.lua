
FACTION.name = "Citizen"
FACTION.description = "A regular human citizen enslaved by the Universal Union."
FACTION.color = Color(150, 125, 100, 255)
FACTION.bgImage = "vgui/project-revival/CitizenBG.png"
FACTION.models = {
	"models/player/zelpa/female_01_extended.mdl",
	"models/player/zelpa/female_02_extended.mdl",
	"models/player/zelpa/female_03_extended.mdl",
	"models/player/zelpa/female_04_extended.mdl",
	"models/player/zelpa/female_06_extended.mdl",
	"models/player/zelpa/female_07_extended.mdl",
	"models/player/zelpa/male_01_extended.mdl",
	"models/player/zelpa/male_02_extended.mdl",
	"models/player/zelpa/male_03_extended.mdl",
	"models/player/zelpa/male_04_extended.mdl",
	"models/player/zelpa/male_05_extended.mdl",
	"models/player/zelpa/male_06_extended.mdl",
	"models/player/zelpa/male_07_extended.mdl",
	"models/player/zelpa/male_08_extended.mdl",
	"models/player/zelpa/male_09_extended.mdl",
	"models/player/zelpa/male_10_extended.mdl",
	"models/player/zelpa/male_11_extended.mdl",
}
FACTION.isDefault = true

function FACTION:OnCharacterCreated(client, character)
	local id = Schema:ZeroNumber(math.random(1, 99999), 5)
	local inventory = character:GetInventory()

	local function round(num, numDecimalPlaces)
		local mult = 10^(numDecimalPlaces or 0)
		return math.floor(num * mult + 0.5) / mult
	end

	character:SetData("cid", id)

	inventory:Add("suitcase", 1)
	inventory:Add("relocationcoupon", 1, {
		name = character:GetName(),
		id = id
	})
	
	-- Gets the change to have a blood type, based off of a statistic I found on google images.
	local bloodNum = math.random(0, 99) + round(math.random(), 2)
	local bloodType = nil

	if bloodNum <= 37.4 then
		bloodType = "O+"
	elseif bloodNum <= 73.1 then
		bloodType = "A+"
	elseif bloodNum <= 81.6 then
		bloodType = "B+"
	elseif bloodNum <= 88.2 then
		bloodType = "O-"
	elseif bloodNum <= 94.5 then
		bloodType = "A-"
	elseif bloodNum <= 97.9 then
		bloodType = "AB+"
	elseif bloodNum <= 99.4 then
		bloodType = "B-"
	elseif bloodNum <= 100 then
		bloodType = "B-"
	else
		bloodType = "Invalid"
	end

	character:SetData("bloodType", bloodType)
	
end

FACTION_CITIZEN = FACTION.index


