SWEP.Base = "tfa_gun_base"
SWEP.Category = "TFA Project HL2"
SWEP.Author	  = "thatrtxdude,Aiden,llopn" --Author Tooltip
SWEP.Manufacturer   =  "Combine Union" --Gun Manufactrer (e.g. Hoeckler and Koch )
SWEP.Purpose		= "Remember you used this during the canals escape? Now you can use this and fire em all!" --Purpose Tooltip
SWEP.Spawnable = true
SWEP.AdminSpawnable = true --Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.UseHands = true --Use gmod c_arms system
SWEP.FiresUnderwater = true

SWEP.PrintName = "Project HL2 Emplacement Gun"
SWEP.DrawCrosshair			= true		-- Draw the crosshair?
SWEP.DrawCrosshairIS = false --Draw the crosshair in ironsights?

SWEP.ViewModel			= "models/weapons/c_IIopnar3.mdl" --Viewmodel path
SWEP.ViewModelFOV = 60

SWEP.WorldModel			= "models/weapons/w_IIopnar3.mdl" --Viewmodel path
SWEP.HoldType = "crossbow"
SWEP.Offset = {
	Pos = {
		Up = -0,
		Right = 0,
		Forward = 0
	},
	Ang = {
		Up = 0,
		Right = 0,
		Forward = 0
	},
	Scale = 1
} --Procedural world model animation, defaulted for CS:S purposes.

SWEP.ThirdPersonReloadDisable = false --Disable third person reload?  True disables.

--SWEP.data 				= {}
--SWEP.data.ironsights			= 0

SWEP.DoMuzzleFlash = true --Do a muzzle flash?
SWEP.CustomMuzzleFlash = false --Disable muzzle anim events and use our custom flashes?
SWEP.AutoDetectMuzzleAttachment = false --For multi-barrel weapons, detect the proper attachment?
SWEP.MuzzleFlashEffect = ( TFA and TFA.YanKys_Realistic_Muzzleflashes ) and "mmod_muzzleflash_Ar3" or "tfa_muzzleflash_lmg"

SWEP.Tracer				= 0		--Bullet tracer.  TracerName overrides this.
SWEP.TracerName 		= nil   --"example" 	--Change to a string of your tracer name.  Can be custom.
								--There is a nice example at https://github.com/garrynewman/garrysmod/blob/master/garrysmod/gamemodes/base/entities/effects/tooltracer.lua
SWEP.TracerCount 		= 1 	--0 disables, otherwise, 1 in X chance


SWEP.TracerLua 			= false --Use lua effect, TFA Muzzle syntax.  Currently obsolete.
SWEP.TracerDelay		= 0.0 --Delay for lua tracer effect


SWEP.ImpactEffect = "AR2Impact"--Impact Effect
SWEP.ImpactDecal = nil--Impact Decal

SWEP.Scoped = false

SWEP.Shotgun = false
SWEP.ShellTime = 0.75

SWEP.DisableChambering = false
SWEP.Primary.ClipSize = 300
SWEP.Primary.DefaultClip = 550

SWEP.Primary.Sound = "Project_MMOD_AR3.Fire"
SWEP.Primary.Ammo = "ar2"
SWEP.Primary.Automatic = true
SWEP.Primary.RPM = 700
SWEP.Primary.Damage = 30
SWEP.Primary.DamageTypeHandled = true --true will handle damagetype in base
SWEP.Primary.DamageType = nill --See DMG enum.  This might be DMG_SHOCK, DMG_BURN, DMG_BULLET, etc.  Leave nil to autodetect. 
SWEP.Primary.Knockback = 0 --Autodetected if nil; this is the velocity kickback
SWEP.Primary.NumShots = 1
SWEP.Primary.Spread		= .02					--This is hip-fire acuracy.  Less is more (1 is horribly awful, .0001 is close to perfect)
SWEP.Primary.IronAccuracy = .01	-- Ironsight accuracy, should be the same for shotguns
SWEP.SelectiveFire = true
SWEP.MoveSpeed = 0.75
SWEP.Slot				= 3
SWEP.SlotPos				= 25	

SWEP.Primary.KickUp			= 0.4					-- This is the maximum upwards recoil (rise)
SWEP.Primary.KickDown			= 0.04					-- This is the maximum downwards recoil (skeet)
SWEP.Primary.KickHorizontal			= 0.03				-- This is the maximum sideways recoil (no real term)
SWEP.Primary.StaticRecoilFactor = 0.7 	--Amount of recoil to directly apply to EyeAngles.  Enter what fraction or percentage (in decimal form) you want.  This is also affected by a convar that defaults to 0.5.

SWEP.Primary.SpreadMultiplierMax = 4.5 --How far the spread can expand when you shoot.
SWEP.Primary.SpreadIncrement = 0.7 --What percentage of the modifier is added on, per shot.
SWEP.Primary.SpreadRecovery = 4.5 --How much the spread recovers, per second.

--[[IRONSIGHTS]]--
SWEP.data = {}
SWEP.data.ironsights = 0 --Enable Ironsights
SWEP.Secondary.IronFOV = 70 --Ironsights FOV (90 = same)
SWEP.BoltAction = false --Un-sight after shooting?
SWEP.BoltTimerOffset = 0.25 --How long do we remain in ironsights after shooting?

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, -0)

SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(0, 0, -0)

SWEP.SafetyPos = Vector(5.66, -1.395, 3.44)
SWEP.SafetyAng = Vector(-8.36, 30.597, 0)

SWEP.InspectPos = Vector(8.541, -7.584, -0.578)
SWEP.InspectAng = Vector(26.906, 18.941, 13.88)

SWEP.CrouchPos = Vector(1.167, -0.172, 2.095)
SWEP.CrouchAng = Vector(-0.174, 0, -6.915)

SWEP.VMPos = Vector(0, 0, 0)

SWEP.Primary.Range = 16 -- The distance the bullet can travel in source units.  Set to -1 to autodetect based on damage/rpm.
SWEP.Primary.RangeFalloff = 0.8 -- The percentage of the range the bullet damage starts to fall off at.  Set to 0.8, for example, to start falling off after 80% of the range.

SWEP.BlowbackEnabled = true
SWEP.BlowbackVector = Vector(0,-2.0,0)
SWEP.Blowback_Shell_Effect = "RifleShellEject"
SWEP.Blowback_PistolMode = true
SWEP.BlowbackBoneMods = {
	--["Bolt"] = { scale = Vector(1, 1, 1), pos = Vector(-3.537, 0, 0), angle = Angle(0, 0, 0) }
}
SWEP.LuaShellEject = false
SWEP.LuaShellEffect = "RifleShellEject"
SWEP.LuaShellEjectDelay = 0

SWEP.StatusLengthOverride = {
	[ACT_VM_RELOAD] = 80 / 60
}

SWEP.SprintAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "Sprint", --Number for act, String/Number for sequence
		["is_idle"] = true
	}
}

SWEP.WalkAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "Walk", --Number for act, String/Number for sequence
		["is_idle"] = true
	},
}

SWEP.AllowViewAttachment = true --Allow the view to sway based on weapon attachment while reloading or drawing, IF THE CLIENT HAS IT ENABLED IN THEIR CONVARS.
SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_ANI -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.Sights_Mode = TFA.Enum.LOCOMOTION_LUA -- ANI = mdl, HYBRID = lua but continue idle, Lua = stop mdl animation
SWEP.Walk_Mode = TFA.Enum.LOCOMOTION_LUA -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.Idle_Mode = TFA.Enum.IDLE_BOTH --TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
SWEP.Idle_Blend = 0.20 --Start an idle this far early into the end of a transition
SWEP.Idle_Smooth = 0.05 --Start an idle this far early into the end of another animation
SWEP.SprintBobMult = 0
