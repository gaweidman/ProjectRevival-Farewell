SWEP.Base					= "tfa_gun_base"
SWEP.Category				= "TFA Project HL2" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep..
SWEP.Manufacturer           =  "Lambda Resistance" --Gun Manufactrer (e.g. Hoeckler and Koch )
SWEP.Description            =  ""
SWEP.Author				    = "thatrtxdude,Aiden,llopn" --Author Tooltip
SWEP.Type 				    = "Anti Tank Weapon"
SWEP.Contact				= "" --Contact Info Tooltip
SWEP.Purpose				= "Given By Odessa. This Menacing Powerful Weapon Can Destroy Any Heavy Enemy" --Purpose Tooltip
SWEP.Instructions				= "" --Instructions Tooltip
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true --Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.DrawCrosshair			= true		-- Draw the crosshair?
SWEP.DrawCrosshairIS = false --Draw the crosshair in ironsights?
SWEP.PrintName				= "Project HL2 RPG"		-- Weapon name (Shown on HUD)
SWEP.Slot				    = 4			-- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos				= 75	-- Position in the slot
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.Weight				    = 40		-- This controls how "good" the weapon is for autopickup.

--[[WEAPON HANDLING]]--
SWEP.Primary.Sound = Sound("Project_MMOD_RPG.Fire") -- This is the sound of the weapon, when you shoot.
SWEP.Primary.PenetrationMultiplier = 0 --Change the amount of something this gun can penetrate through
SWEP.Primary.Damage = 200 -- Damage, in standard damage points.
SWEP.Primary.NumShots = 1 --The number of shots the weapon fires.  SWEP.Shotgun is NOT required for this to be >1.
SWEP.Primary.Automatic = false -- Automatic/Semi Auto
SWEP.Primary.RPM = 250 -- This is in Rounds Per Minute / RPM
SWEP.Primary.DryFireDelay = nil --How long you have to wait after firing your last shot before a dryfire animation can play.  Leave nil for full empty attack length.  Can also use SWEP.StatusLength[ ACT_VM_BLABLA ]
SWEP.Primary.BurstDelay = nil -- Delay between bursts, leave nil to autocalculate
SWEP.IronSightTime = -0.92
SWEP.FiresUnderwater = false

SWEP.viewkickxmult = 0.20
SWEP.viewkickymult = 0.30
SWEP.viewkickzmult = 1

SWEP.CrouchPos = Vector(0, 0, -4.889)
SWEP.CrouchAng = Vector(0, 1.812, -22.462)

SWEP.Primary.Projectile = "tfa_exp_contact"
SWEP.Primary.ProjectileModel = "models/weapons/w_missile_closed.mdl"
SWEP.Primary.ProjectileVelocity = 12332.5 * 16 / 12-- 295 meters to inches * 4/3 ( 16 / 12 hammer to inches )

--Miscelaneous Sounds
SWEP.IronInSound = Sound( "Project_MMOD_Weapon_Generic.ADSIn")  --Sound to play when ironsighting in?  nil for default
SWEP.IronOutSound = Sound( "Project_MMOD_Weapon_Generic.ADSOut") --Sound to play when ironsighting out?  nil for default
--Silencing
SWEP.CanBeSilenced = false --Can we silence?  Requires animations.
SWEP.Silenced = false --Silenced by default?
-- Selective Fire Stuff
SWEP.SelectiveFire = false --Allow selecting your firemode?
SWEP.DisableBurstFire = false --Only auto/single?
SWEP.OnlyBurstFire = false --No auto, only burst/single?
SWEP.DefaultFireMode = "" --Default to auto or whatev
SWEP.FireModeName = "Single-Shot" --Change to a text value to override it
--Ammo Related
SWEP.Primary.ClipSize = 1 -- This is the size of a clip
SWEP.Primary.DefaultClip = 3 -- This is the number of bullets the gun gives you, counting a clip as defined directly above.
SWEP.Primary.Ammo = "RPG_Round" -- What kind of ammo.  Options, besides custom, include pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, and AirboatGun.
SWEP.Primary.AmmoConsumption = 1 --Ammo consumed per shot
--Pistol, buckshot, and slam like to ricochet. Use AirboatGun for a light metal peircing shotgun pellets
SWEP.DisableChambering = true --Disable round-in-the-chamber

--Recoil Related
SWEP.Primary.KickUp = 0.58 -- This is the maximum upwards recoil (rise)
SWEP.Primary.KickDown = 0.27 -- This is the maximum downwards recoil (skeet)
SWEP.Primary.KickHorizontal = 0.07  -- This is the maximum sideways recoil (no real term)
SWEP.Primary.StaticRecoilFactor = 0.5 --Amount of recoil to directly apply to EyeAngles.  Enter what fraction or percentage (in decimal form) you want.  This is also affected by a convar that defaults to 0.5.
--Firing Cone Related
SWEP.Primary.Spread = .020 --This is hip-fire acuracy.  Less is more (1 is horribly awful, .0001 is close to perfect)
SWEP.Primary.IronAccuracy = .015 -- Ironsight accuracy, should be the same for shotguns
--Unless you can do this manually, autodetect it.  If you decide to manually do these, uncomment this block and remove this line.
SWEP.Primary.SpreadMultiplierMax = 7--How far the spread can expand when you shoot. Example val: 2.5
SWEP.Primary.SpreadIncrement = 3 --What percentage of the modifier is added on, per shot.  Example val: 1/3.5
SWEP.Primary.SpreadRecovery = 7--How much the spread recovers, per second. Example val: 3
--Range Related
SWEP.Primary.Range = 350 * 45.822 * 7 / 3 -- The distance the bullet can travel in source units.  Set to -1 to autodetect based on damage/rpm.
SWEP.Primary.RangeFalloff = 0.5 -- The percentage of the range the bullet damage starts to fall off at.  Set to 0.8, for example, to start falling off after 80% of the range.
--Penetration Related
SWEP.MaxPenetrationCounter = 3 --The maximum number of ricochets.  To prevent stack overflows.
--Misc
SWEP.IronRecoilMultiplier = 0.5 --Multiply recoil by this factor when we're in ironsights.  This is proportional, not inversely.
SWEP.CrouchAccuracyMultiplier = 0.5 --Less is more.  Accuracy * 0.5 = Twice as accurate, Accuracy * 0.1 = Ten times as accurate
--Movespeed
SWEP.MoveSpeed = 0.65 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = SWEP.MoveSpeed * 0.6 --Multiply the player's movespeed by this when sighting.
--[[VIEWMODEL]]--
SWEP.ViewModel			= "models/weapons/c_iiopnrpg.mdl" --Viewmodel path
SWEP.ViewModelFOV			= 63		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip			= false		-- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands = true --Use gmod c_arms system.
SWEP.VMPos = Vector(0, 0, 0)
SWEP.VMAng = Vector(0,0,0)
SWEP.VMPos_Additive = false --Set to false for an easier time using VMPos. If true, VMPos will act as a constant delta ON TOP OF ironsights, run, whateverelse
SWEP.CenteredPos = nil --The viewmodel positional offset, used for centering.  Leave nil to autodetect using ironsights.
SWEP.CenteredAng = nil --The viewmodel angular offset, used for centering.  Leave nil to autodetect using ironsights.
--[[WORLDMODEL]]--
SWEP.WorldModel			= "models/weapons/w_iiopnrpg.mdl" -- Weapon world model path
SWEP.Bodygroups_W = {}
SWEP.HoldType = "rpg" -- This is how others view you carrying the weapon. Options include:
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive
-- You're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles
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

--[[SCOPES]]--
SWEP.IronSightsSensitivity = 1 --Useful for a RT scope.  Change this to 0.25 for 25% sensitivity.  This is if normal FOV compenstaion isn't your thing for whatever reason, so don't change it for normal scopes.
SWEP.BoltAction = false --Unscope/sight after you shoot?
SWEP.Scoped = false --Draw a scope overlay?
SWEP.ScopeOverlayThreshold = 0.899 --Percentage you have to be sighted in to see the scope.
SWEP.BoltTimerOffset = 0.25 --How long you stay sighted in after shooting, with a bolt action.
SWEP.ScopeScale = 0.5 --Scale of the scope overlay
SWEP.ReticleScale = 0.7 --Scale of the reticle overlay
--GDCW Overlay Options.  Only choose one.
SWEP.Secondary.UseACOG = false --Overlay option
SWEP.Secondary.UseMilDot = false --Overlay option
SWEP.Secondary.UseSVD = false --Overlay option
SWEP.Secondary.UseParabolic = false --Overlay option
SWEP.Secondary.UseElcan = false --Overlay option

--[[SHOTGUN CODE]]--
SWEP.Shotgun = false --Enable shotgun style reloading.

--[[SPRINTING]]--
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-5, 0, 0)
SWEP.SafetyPos = Vector(0, 0, -0.447)
SWEP.SafetyAng = Vector(-6.935, -5.187, -2.237)

--[[IRONSIGHTS]]--
SWEP.data = {}
SWEP.data.ironsights = 1 --Enable Ironsights
SWEP.Secondary.IronFOV = 75 -- How much you 'zoom' in. Less is more!  Don't have this be <= 0.  A good value for ironsights is like 70.
SWEP.IronSightsPos = Vector(-0.612, -1.287, 1.037)
SWEP.IronSightsAng = Vector(0, 0, -1.887)
SWEP.RTBGBlur = false

--[[INSPECTION]]--
SWEP.InspectPos = Vector(5.298, -0.232, 0)
SWEP.InspectAng = Vector(9.907, 19.461, 0)

--[[VIEWMODEL ANIMATION HANDLING]]--
SWEP.AllowViewAttachment = true --Allow the view to sway based on weapon attachment while reloading or drawing, IF THE CLIENT HAS IT ENABLED IN THEIR CONVARS.

--[[ANIMATION]]--

SWEP.ProceduralHoslterEnabled = nil
SWEP.ProceduralHolsterTime = 0.3
SWEP.ProceduralHolsterPos = Vector(3, 0, -5)
SWEP.ProceduralHolsterAng = Vector(-40, -30, 10)


SWEP.Sights_Mode = TFA.Enum.LOCOMOTION_HYBRID -- ANI = mdl, HYBRID = lua but continue idle, Lua = stop mdl animation
SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_ANI -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.Walk_Mode = TFA.Enum.LOCOMOTION_ANI -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.Idle_Mode = TFA.Enum.IDLE_BOTH --TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
SWEP.Idle_Blend = 0.25 --Start an idle this far early into the end of a transition
SWEP.Idle_Smooth = 0.05 --Start an idle this far early into the end of another animation
--MDL Animations Below

SWEP.WalkAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "Walk", --Number for act, String/Number for sequence
		["is_idle"] = true
	}, --What do you think
}

SWEP.SprintAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "Sprint", --Number for act, String/Number for sequence
		["is_idle"] = true
	}
}
--[[EFFECTS]]--
--Attachments
SWEP.MuzzleAttachment			= "muzzle" 		-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellAttachment			= "shell" 		-- Should be "2" for CSS models or "shell" for hl2 models
SWEP.MuzzleFlashEnabled = true --Enable muzzle flash
SWEP.MuzzleAttachmentRaw = nil --This will override whatever string you gave.  This is the raw attachment number.  This is overridden or created when a gun makes a muzzle event.
SWEP.AutoDetectMuzzleAttachment = false --For multi-barrel weapons, detect the proper attachment?
SWEP.MuzzleFlashEffect = ( TFA and TFA.YanKys_Realistic_Muzzleflashes ) and "mmod_muzzleflash_rpg" or "tfa_muzzleflash_shotgun"
SWEP.SmokeParticle = nil --Smoke particle (ID within the PCF), defaults to something else based on holdtype; "" to disable
SWEP.EjectionSmokeEnabled = false --Disable automatic ejection smoke
--Shell eject override
SWEP.LuaShellEject = false --Enable shell ejection through lua?
SWEP.LuaShellEjectDelay = 0.10 --The delay to actually eject things
SWEP.LuaShellEffect = " " --The effect used for shell ejection; Defaults to that used for blowback
--Tracer Stuff
SWEP.TracerName 		= nil 	--Change to a string of your tracer name.  Can be custom. There is a nice example at https://github.com/garrynewman/garrysmod/blob/master/garrysmod/gamemodes/base/entities/effects/tooltracer.lua
SWEP.TracerCount 		= 0 	--0 disables, otherwise, 1 in X chance
--Impact Effects
SWEP.ImpactEffect = nil--Impact Effect
SWEP.ImpactDecal = nil--Impact Decal

--[[EVENT TABLE]]--
SWEP.EventTable = {
	[ACT_VM_RELOAD] = {
	    {time = 1 / 30, type = "sound", value = Sound("Project_MMOD_RPG.Reload")},
	},	
}

SWEP.StatusLengthOverride = {
	[ACT_VM_RELOAD] = 37 / 60
}

--[[AKIMBO]]--
SWEP.Akimbo = false --Akimbo gun?  Alternates between primary and secondary attacks.
SWEP.AnimCycle = 0 -- Start on the right

SWEP.LaserToggleDelay = .3

DEFINE_BASECLASS( SWEP.Base )

function SWEP:SetupDataTables(...)
	self:NetworkVar("Entity", 10, "RocketEntity")
	self:NetworkVar("Entity", 11, "SpotEntity")
	self:NetworkVar("Float", 12, "SpotDelay")
	return BaseClass.SetupDataTables(self,...)
end

function SWEP:Holster(...)
	if self:IsRocketActive() && self:IsSpotActive() then
		return false
	end
	local spotEnt = self:GetSpotEntity()
	if IsFirstTimePredicted() and IsValid(spotEnt) then
		spotEnt:SetNoDraw(true)
	end
	
	return BaseClass.Holster(self,...)
end

function SWEP:OnRemove(...)
	local spotEnt = self:GetSpotEntity()
	if SERVER and IsValid(spotEnt) then
		spotEnt:Remove()
	end
	return BaseClass.OnRemove(self,...)
end

function SWEP:OnDrop(...)
	self:OnRemove()
	return BaseClass.OnDrop(self,...)
end

function SWEP:Reload(...)
	if self:IsRocketActive() && self:IsSpotActive() then
		return false
	end
	
	if self:Clip1() <= 0 and self:IsSpotActive() then
		if SERVER then self:GetSpotEntity():Suspend(2.1) end
		self:SetSpotDelay(CurTime() + 2.1)
	end
	
	return BaseClass.Reload(self,...)
end

function SWEP:CanPrimaryAttack(...)
	if self:IsRocketActive() && self:IsSpotActive() then
		return false
	end
	
	return BaseClass.CanPrimaryAttack(self,...)
end

function SWEP:ShootBulletInformation()
	local ang = self.Owner:GetAimVector():Angle()
	local vecSrc = self.Owner:GetShootPos() + ang:Forward() * 16 + ang:Right() * 8 - ang:Up() * 8

	if SERVER then
		local pRocket = ents.Create("pjmmod_rpg_missile")
		if self:IsSpotActive() then
			self:SetRocketEntity(pRocket)
		end
		if IsValid(pRocket) then
			pRocket:SetPos(vecSrc)
			pRocket:SetAngles(ang)
			pRocket.dmg = self.Primary.Damage
			pRocket:Spawn()
			if self:IsSpotActive() then
				pRocket.bGuiding = true
			end
			pRocket.pLauncher = self
			pRocket:SetOwner(self.Owner)
			pRocket:SetLocalVelocity(pRocket:GetVelocity() + self.Owner:GetForward() * self.Owner:GetVelocity():Dot(self.Owner:GetForward()))
		end
	end
end

function SWEP:AltAttack()
	if self:GetSpotDelay() > CurTime() then return end
	
	local spotEnt = self:GetSpotEntity()
	if !IsValid(spotEnt) then
		self:UpdateSpot()
	else
		if spotEnt:GetDrawLaser() then
			spotEnt:SetDrawLaser(false)
			self:EmitSound("Weapon_RPG.LaserOff")
		else
			spotEnt:SetDrawLaser(true)
			spotEnt:SetPos(self.Owner:GetEyeTrace().HitPos)
			self:EmitSound("Weapon_RPG.LaserOn")
		end
	end
	self:SetSpotDelay(CurTime() + self.LaserToggleDelay)
end

function SWEP:UpdateSpot()
	if !IsValid(self:GetSpotEntity()) then
		if SERVER then self:SetSpotEntity(ents.Create("pjmmod_laserdot")) end
		local spotEnt = self:GetSpotEntity()
		if IsValid(spotEnt) then
			spotEnt:SetPos(self.Owner:GetEyeTrace().HitPos)
			spotEnt:SetOwner(self.Owner)
			spotEnt:Spawn()
			spotEnt:SetDrawLaser(true)
		end
	end
	local spotEnt = self:GetSpotEntity()
	if SERVER and IsValid(spotEnt) and spotEnt:GetDrawLaser() then
		spotEnt:SetNoDraw(false)
		spotEnt:SetPos(self.Owner:GetEyeTrace().HitPos)
	end
end

function SWEP:IsSpotActive()
	local spotEnt = self:GetSpotEntity()
	return spotEnt && IsValid(spotEnt) && spotEnt:GetDrawLaser()
end

function SWEP:IsRocketActive()
	local rocketEnt = self:GetRocketEntity()
	return IsValid(rocketEnt) && !rocketEnt.didHit
end

function SWEP:Think2(...)
	self:UpdateSpot()
	self.Bodygroups_V[1] = ( self:Clip1() <= 0 and self:GetStatus() ~= TFA.GetStatus("reloading") ) and 1 or 0
	return BaseClass.Think2(self,...)
end