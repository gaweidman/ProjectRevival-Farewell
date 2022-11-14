-- Variables that are used on both client and server
SWEP.Gun = ("weapon_fraggrenade")
SWEP.Category				= "Fallout RP"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
if CLIENT then
SWEP.PrintName				= L("Frag grenade")			-- Weapon name (Shown on HUD)
SWEP.Instructions			= L("itemFragGrenadeDesc")	-- Weapon instructions (Shown on HUD)
end
SWEP.Slot				= 4				-- Slot in the weapon selection menu
SWEP.SlotPos				= 21			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- set false if you want no crosshair
SWEP.Weight 				= 5		-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and ar2 make for good sniper rifles

local ActIndex = {}		
	ActIndex["pistol"] 		= ACT_HL2MP_IDLE_PISTOL
	ActIndex["smg"] 			= ACT_HL2MP_IDLE_SMG1
	ActIndex["grenade"] 		= ACT_HL2MP_IDLE_GRENADE
	ActIndex["ar2"] 			= ACT_HL2MP_IDLE_AR2
	ActIndex["shotgun"] 		= ACT_HL2MP_IDLE_SHOTGUN
	ActIndex["rpg"]	 		= ACT_HL2MP_IDLE_RPG
	ActIndex["physgun"] 		= ACT_HL2MP_IDLE_PHYSGUN
	ActIndex["crossbow"] 		= ACT_HL2MP_IDLE_CROSSBOW
	ActIndex["melee"] 		= ACT_HL2MP_IDLE_MELEE
	ActIndex["slam"] 			= ACT_HL2MP_IDLE_SLAM
	ActIndex["normal"]		= ACT_HL2MP_IDLE
	ActIndex["knife"]			= ACT_HL2MP_IDLE_KNIFE
	ActIndex["sword"]			= ACT_HL2MP_IDLE_MELEE2
	ActIndex["passive"]		= ACT_HL2MP_IDLE_PASSIVE
	ActIndex["fist"]			= ACT_HL2MP_IDLE_FIST

local ActIndex = {
	[ "pistol" ] 		= ACT_HL2MP_IDLE_PISTOL,
	[ "revolver" ] 		= ACT_HL2MP_IDLE_REVOLVER,
	[ "smg" ] 			= ACT_HL2MP_IDLE_SMG1,
	[ "grenade" ] 		= ACT_HL2MP_IDLE_GRENADE,
	[ "ar2" ] 			= ACT_HL2MP_IDLE_AR2,
	[ "shotgun" ] 		= ACT_HL2MP_IDLE_SHOTGUN,
	[ "rpg" ]	 		= ACT_HL2MP_IDLE_RPG,
	[ "physgun" ] 		= ACT_HL2MP_IDLE_PHYSGUN,
	[ "crossbow" ] 		= ACT_HL2MP_IDLE_CROSSBOW,
	[ "melee" ] 		= ACT_HL2MP_IDLE_MELEE,
	[ "slam" ] 			= ACT_HL2MP_IDLE_SLAM,
	[ "normal" ]		= ACT_HL2MP_IDLE,
	[ "fist" ]			= ACT_HL2MP_IDLE_FIST,
	[ "melee2" ]		= ACT_HL2MP_IDLE_MELEE2,
	[ "passive" ]		= ACT_HL2MP_IDLE_PASSIVE,
	[ "knife" ]			= ACT_HL2MP_IDLE_KNIFE
}

SWEP.HoldType			 = "grenade"
SWEP.ViewModelFOV 		= 80
SWEP.ViewModelFlip 		= true
SWEP.ViewModel 			= "models/weapons/v_eq_flashbang.mdl"
SWEP.WorldModel 		= "models/halokiller38/fallout/weapons/explosives/fraggrenade.mdl"
SWEP.ShowViewModel 		= true
SWEP.ShowWorldModel 	= true
SWEP.Base				= "boh_gun_base"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.FiresUnderwater 	= true
SWEP.ViewModelBoneMods = {
	["Bip01_L_Forearm"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Bip01_L_Hand"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["HandControlRotR"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["HandControlRotParentR"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Detonator"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Slam_panel"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["HandControlRotR1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["HandControlRotGrandmaR"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Slam_base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Bip01_L_UpperArm"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Bip01_L_Clavicle"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(30, 30, -30), angle = Angle(-180, 0, 0) },
	["v_weapon.Flashbang_Parent"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = Vector(10, 10, 10)	-- These are the same as IronSightPos and IronSightAng
SWEP.SightsAng = Vector(0, 0, 0)	-- No, I don't know why
SWEP.RunSightsPos = Vector (-20.6657, 0, 3.5)
SWEP.RunSightsAng = Vector(0, 0, 0)

SWEP.Primary.Sound			= Sound("")		-- Script that calls the primary fire sound
SWEP.Primary.RPM				= 30		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 1		-- Size of a clip
SWEP.Primary.DefaultClip		= 0		-- Bullets you start with
SWEP.Primary.KickUp				= 0		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "FragGrenade"				
-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a metal peircing shotgun slug

SWEP.Primary.Round 			= ("halo_thrown_frag")	--NAME OF ENTITY GOES HERE

SWEP.Secondary.IronFOV		= 0		-- How much you 'zoom' in. Less is more! 	
SWEP.Primary.NumShots		= 0		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage			= 0	-- Base damage per bullet
SWEP.Primary.Spread			= 0	-- Define from-the-hip accuracy (1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy 	= 0 -- Ironsight accuracy, should be the same for shotguns

SWEP.VElements = {
	["grenade"] = { type = "Model", model = "models/halokiller38/fallout/weapons/explosives/fraggrenade.mdl", bone = "v_weapon.Flashbang_Parent", rel = "", pos = Vector(0.36, -2.961, 0), angle = Angle(0.228, -9.11, 90.253), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["grenade"] = { type = "Model", model = "models/halokiller38/fallout/weapons/explosives/fraggrenade.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.144, 1.847, 0.727), angle = Angle(180, 180, 0), size = Vector(1.302, 1.302, 1.302), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:PrimaryAttack()
	if self.Owner:IsNPC() then return end
	if self:CanPrimaryAttack() then
		self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)
		
		self.Weapon:SetNextPrimaryFire(CurTime()+1/(self.Primary.RPM/60))	
		timer.Simple( 0.6, function() if SERVER then if not IsValid(self) then return end 
			if IsValid(self.Owner) then 
				if (self:AllIsWell()) then 
					self:Throw() 
				end 
			end
		end end )
	end
end

function SWEP:Throw()

	if SERVER then
	
	if self.Owner != nil and self.Weapon != nil then 
	if self.Owner:GetActiveWeapon():GetClass() == self.Gun then

	self.Weapon:SendWeaponAnim(ACT_VM_THROW)
	timer.Simple( 0.35, function() if not IsValid(self) then return end 
	if self.Owner != nil
	and self.Weapon != nil
	then if(self:AllIsWell()) then 
	self.Owner:SetAnimation(PLAYER_ATTACK1)
			aim = self.Owner:GetAimVector()
			side = aim:Cross(Vector(0,0,1))
			up = side:Cross(aim)
			pos = self.Owner:GetShootPos() + side * 5 + up * -1
			if SERVER then
				local rocket = ents.Create(self.Primary.Round)
				if !rocket:IsValid() then return false end
				rocket:SetNWEntity("Owner", self.Owner)
				rocket:SetAngles(aim:Angle()+Angle(90,0,0))
				rocket:SetPos(pos)
				rocket:SetOwner(self.Owner)
				rocket.Owner = self.Owner	-- redundancy department of redundancy checking in
				rocket:SetNWEntity("Owner", self.Owner)
				rocket:Spawn()
				local phys = rocket:GetPhysicsObject()
				if self.Owner:KeyDown(IN_ATTACK2) and (phys:IsValid()) then
					if phys != nil then phys:ApplyForceCenter(self.Owner:GetAimVector() * 2300) end
				else 
					if phys != nil then phys:ApplyForceCenter(self.Owner:GetAimVector() * 3500) end
				end
				self.Weapon:TakePrimaryAmmo(1)
		end
		self:checkitycheckyoself()
		end end
	end )
		
	end
	end
	end
end

function SWEP:SecondaryAttack()
end	

function SWEP:checkitycheckyoself()
	timer.Simple(.15, function() if not IsValid(self) then return end 
	if IsValid(self.Owner) then 
	if SERVER and (self:AllIsWell()) then	
		if self.Weapon:Clip1() == 0 
			and self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() ) == 0 then
				self.Owner:StripWeapon(self.Gun)
			else
				self.Weapon:DefaultReload( ACT_VM_DRAW )
			end
		end
	end end)
end

function SWEP:AllIsWell()

	if self.Owner != nil and self.Weapon != nil then
		if self.Weapon:GetClass() == self.Gun and self.Owner:Alive() then
			return true
			else return false
		end
		else return false
	end

end

function SWEP:Think()
end