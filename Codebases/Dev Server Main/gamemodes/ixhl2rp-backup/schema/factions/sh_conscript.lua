
FACTION.name = "Human Earth Military"
FACTION.description = "A fully human soldier located Earth."
FACTION.color = Color(38, 145, 63, 255)
FACTION.models = {
	"models/wichacks/artnovest.mdl",
	"models/wichacks/erdimnovest.mdl",
	"models/wichacks/ericnovest.mdl",
	"models/wichacks/joenovest.mdl",
	"models/wichacks/mikenovest.mdl",
	"models/wichacks/sandronovest.mdl",
	"models/wichacks/tednovest.mdl",
	"models/wichacks/vannovest.mdl",
	"models/wichacks/vancenovest.mdl",
	"models/models/army/female_01.mdl",
	"models/models/army/female_02.mdl",
	"models/models/army/female_03.mdl",
	"models/models/army/female_04.mdl",
	"models/models/army/female_06.mdl",
	"models/models/army/female_07.mdl",
}

FACTION.isDefault = false
FACTION.isGloballyRecognized = false

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	inventory:Add("conscripthazmatarmor", 1)
	
	character:SetName("Recruit "..character:GetName())
end

FACTION_CONSCRIPT = FACTION.index