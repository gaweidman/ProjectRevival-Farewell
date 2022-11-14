local PLUGIN = PLUGIN

PLUGIN.name = "John Cena"
PLUGIN.description = "Make wooden props absorb fall damages."
PLUGIN.author = "ExtReMLapin"
PLUGIN.props = {}

PLUGIN.props["models/props_interiors/furniture_shelf01a.mdl"] = true
PLUGIN.props["models/props_c17/furnituredrawer001a_chunk01.mdl"] = true
PLUGIN.props["models/props_wasteland/wood_fence01a.mdl"] = true
PLUGIN.props["models/props_junk/watermelon01.mdl"] = true
PLUGIN.props["models/props_lab/dogobject_wood_crate001a_damagedmax.mdl"] = true
PLUGIN.props["models/props_junk/wood_crate001a_damaged.mdl"] = true
PLUGIN.props["models/props_c17/furnitureshelf001b.mdl"] = true
PLUGIN.props["models/props_c17/furnituredrawer001a.mdl"] = true
PLUGIN.props["models/gibs/furniture_gibs/furniturewooddrawer003a_chunk02.mdl"] = true
PLUGIN.props["models/props_interiors/furniture_desk01a.mdl"] = true
PLUGIN.props["models/props_c17/furniturecupboard001a.mdl"] = true
PLUGIN.props["models/props_debris/wood_board06a.mdl"] = true
PLUGIN.props["models/props_junk/wood_pallet001a.mdl"] = true
PLUGIN.props["models/props_phx/construct/wood/wood_panel1x1"] = true
PLUGIN.props["models/props_phx/construct/wood/wood_panel2x2"] = true
PLUGIN.props["models/props_lab/box01a.mdl"] = true
PLUGIN.props["models/props_wasteland/wood_fence02a.mdl"] = true
PLUGIN.props["models/props_phx/construct/wood/wood_panel4x4"] = true
PLUGIN.props["models/props_c17/furnitureshelf001a.mdl"] = true
PLUGIN.props["models/props_junk/cardboard_box001a.mdl"] = true
PLUGIN.props["models/props_junk/cardboard_box004a.mdl"] = true
PLUGIN.props["models/props_junk/wood_crate001a.mdl"] = true
PLUGIN.props["models/props_junk/cardboard_box003b.mdl"] = true
PLUGIN.props["models/props_junk/cardboard_box003a.mdl"] = true
PLUGIN.props["models/props_junk/cardboard_box002a.mdl"] = true
PLUGIN.props["models/props_junk/wood_crate002a.mdl"] = true
PLUGIN.props["models/props_junk/cardboard_box002b.mdl"] = true
PLUGIN.props["models/props_junk/cardboard_box001b.mdl"] = true
PLUGIN.props["models/props/de_prodigy/wood_pallet_01.mdl"] = true
PLUGIN.props["models/props_debris/wood_board01a.mdl"] = true
PLUGIN.props["models/props_debris/wood_board02a.mdl"] = true
PLUGIN.props["models/props_debris/wood_board04a.mdl"] = true
PLUGIN.props["models/props_debris/wood_chunk01c.mdl"] = true
PLUGIN.props["models/props_debris/wood_chunk01a.mdl"] = true

PLUGIN.classes = {
	func_breakable = true,
	prop_physics = true
}

local offsetVector = Vector(0, 0, 15)
local playerWeight = 70 -- kg

-- any object heavier than 50% of the weight of the player will not absorb damages
local offsetWeightObject = playerWeight

function PLUGIN:GetFallDamage(ply, speed)
	if (ply:GetCharacter() and ply:GetCharacter():GetAttribute("str", 0)) then
		offsetWeightObject = 70 + ply:GetCharacter():GetAttribute("str", 0) * ix.config.Get("strengthMultiplier", 1)
	end
	
	local damage = (speed - 580) * (100 / 444)

	local tr = util.TraceHull({
			start = ply:GetPos(),
			endpos = ply:GetPos() - offsetVector,
			filter = ply,
			mins = Vector(-18, -18, 0),
			maxs = Vector(18, 18, 15)
		})
	if not tr.Hit or not tr.HitNonWorld then
		return
	end

	local hitEntity = tr.Entity
	local class = hitEntity:GetClass()
	if not self.classes[class] then return end

	if not self.props[hitEntity:GetModel()] then return damage end
	local phys = hitEntity:GetPhysicsObject()
	if not phys then return end
	local entMass = phys:GetMass()

	if (offsetWeightObject < entMass) then
		return damage
	end

	hitEntity:Fire("Break", "", 0);

	return damage * math.Remap(entMass, 0, offsetWeightObject, 1, 0.5)
end