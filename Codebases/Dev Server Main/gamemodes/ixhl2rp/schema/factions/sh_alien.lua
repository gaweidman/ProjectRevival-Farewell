
FACTION.name = "Alien Lifeform"
FACTION.description = "A creature from Xen, the world of Race X, or elsewhere."
FACTION.color = Color(144, 211, 19, 255)
FACTION.models = {
	"models/half-life/chumtoad.mdl",
	"models/headcrabclassic.mdl",
	"models/headcrab.mdl",
	"models/headcrabblack.mdl",
	"models/Zombie/Classic.mdl",
	"models/Zombie/Fast.mdl",
	"models/Zombie/Poison.mdl",
	"models/AntLion.mdl"
}

FACTION.bgImage = "vgui/project-revival/AlienBG.png"
FACTION.isDefault = false

function FACTION:OnCharacterCreated(client, character)
	if character:GetModel() == "models/half-life/chumtoad.mdl" then
		character:SetClass(CLASS_CHUMTOAD)
	elseif character:GetModel() == "models/headcrabclassic.mdl" or character:GetModel() == "models/headcrab.mdl" or character:GetModel() == "models/headcrabblack.mdl" then
		character:SetClass(CLASS_HEADCRAB)
	elseif character:GetModel() == "models/Zombie/Classic.mdl" or character:GetModel() == "models/Zombie/Fast.mdl" or character:GetModel() == "models/Zombie/Poison.mdl" then
		character:SetClass(CLASS_ZOMBIE)
	elseif character:GetModel() == "models/AntLion.mdl" then
		character:SetClass(CLASS_ANTLION)
	end
end

FACTION_ALIEN = FACTION.index