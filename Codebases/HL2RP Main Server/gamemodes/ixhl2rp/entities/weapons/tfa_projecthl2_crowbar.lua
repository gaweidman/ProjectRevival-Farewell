SWEP.Base = "tfa_melee_base"
DEFINE_BASECLASS(SWEP.Base)
SWEP.Category = "TFA Project HL2"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.UseHands = true
SWEP.Type_Displayed = "Prying Tool."
SWEP.Author = "thatrtxdude"
SWEP.Purpose = "The right man in the wrong place can make all the difference in the world."
SWEP.Slot = 0
SWEP.PrintName = "Project HL2 Crowbar"
SWEP.DrawCrosshair = true

--[Model]--
SWEP.ViewModel = "models/weapons/c_IIopncrowbar.mdl"
SWEP.ViewModelFOV = 70
SWEP.WorldModel = "models/weapons/w_IIopncrowbar.mdl"
SWEP.HoldType = "melee"
SWEP.CameraAttachmentOffsets = {}
SWEP.CameraAttachmentScale = 2

SWEP.RunSightsPos = Vector(0, -15.096, 0)
SWEP.RunSightsAng = Vector(32.382, 0, 0)

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = -4.5,
        Right = 1,
        Forward = 4,
        },
        Ang = {
		Up = 90,
        Right = -5,
        Forward = -180
        },
		Scale = 1
}

--[Gun Related]--
SWEP.Primary.Sound = Sound("HL2.CROWBAR.HIT")
SWEP.Primary.Sound_Hit = Sound("Weapon_Crowbar.Melee_Hit")
SWEP.Primary.Sound_HitFlesh = Sound("HL2.CROWBAR.HIT")
SWEP.Primary.DamageType = bit.bor(DMG_CLUB, DMG_SLASH)
SWEP.Primary.RPM = 100
SWEP.Primary.Damage = 30
SWEP.Primary.MaxCombo = 0
SWEP.Secondary.MaxCombo = 0

--SWEP.Primary.Automatic = false
--SWEP.Secondary.Automatic = false

--[Traces]--
SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_MISSCENTER, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 65, -- Trace distance
		["src"] = Vector(0, 0, 0), -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(-15, 1, -35), -- Trace direction/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dmg"] = SWEP.Primary.Damage, --Damage
		["dmgtype"] = SWEP.Primary.DamageType,
		["delay"] = 3 / 30, --Delay
		["spr"] = false, --Allow attack while sprinting?
		["snd"] = SWEP.Primary.Sound, -- Sound ID
		["hitflesh"] = SWEP.Primary.Sound_HitFlesh,
		["hitworld"] = SWEP.Primary.Sound_Hit,
		["viewpunch"] = Angle(0, 0, 0), --viewpunch angle
		["end"] = 0.5, --time before next attack
		["hull"] = 1, --Hullsize
	},
	{
		["act"] = ACT_VM_MISSCENTER, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 65, -- Trace distance
		["src"] = Vector(0, 0, 0), -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(-35, 1, 0), -- Trace direction/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dmg"] = SWEP.Primary.Damage, --Damage
		["dmgtype"] = SWEP.Primary.DamageType,
		["delay"] = 3 / 30, --Delay
		["spr"] = false, --Allow attack while sprinting?
		["snd"] = SWEP.Primary.Sound, -- Sound ID
		["hitflesh"] = SWEP.Primary.Sound_HitFlesh,
		["hitworld"] = SWEP.Primary.Sound_Hit,
		["viewpunch"] = Angle(0, 0, 0), --viewpunch angle
		["end"] = 0.5, --time before next attack
		["hull"] = 1, --Hullsize
	},
	{
		["act"] = ACT_VM_MISSCENTER, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 65, -- Trace distance
		["src"] = Vector(0, 0, 0), -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(-45, 1, 0), -- Trace direction/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dmg"] = SWEP.Secondary.Damage, --Damage
		["dmgtype"] = SWEP.Primary.DamageType,
		["delay"] = 3 / 30, --Delay
		["spr"] = false, --Allow attack while sprinting?
		["snd"] = SWEP.Primary.Sound, -- Sound ID
		["hitflesh"] = SWEP.Primary.Sound_HitFlesh,
		["hitworld"] = SWEP.Primary.Sound_Hit,
		["viewpunch"] = Angle(0, 0, 0), --viewpunch angle
		["end"] = 0.5, --time before next attack
		["hull"] = 1, --Hullsize
	},
}

--[Stuff]--
SWEP.ImpactDecal = "ManhackCut"
SWEP.InspectPos = Vector(2, -2, -9)
SWEP.InspectAng = Vector(25, 15, 0)

SWEP.WalkAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, 
		["value"] = "Walk", 
		["is_idle"] = true
	},
}

SWEP.SprintAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ,
		["value"] = "Sprint",
		["value_empty"] = "Sprint",
		["is_idle"] = true,
	},

}


--SWEP.AltAttack = false
SWEP.AllowSprintAttack = false

--[Tables]--
SWEP.EventTable = {
	[ACT_VM_DRAW] = {
		{["time"] = 0, ["type"] = "sound", ["value"] = Sound("HL2.CROWBAR.DRAW"), ["server"] = false, ["client"] = true},
	},
}

SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_ANI -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.Walk_Mode = TFA.Enum.LOCOMOTION_ANI -- ANI = mdl, HYBRID = ani + lua, Lua = lua only