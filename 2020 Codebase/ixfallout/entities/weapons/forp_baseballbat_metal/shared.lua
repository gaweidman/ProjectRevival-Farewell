SWEP.Base = "sword_swepbase"

if CLIENT then
SWEP.PrintName = L("Baseball bat")
SWEP.Instructions = L("Primary Fire: Attack.\nSecondary Fire: Guard.\nR: Parry.")
end
SWEP.Category = "Fallout RP"
SWEP.Author = "Barata"

SWEP.Purpose = ""

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

-- For parrying
SWEP.StrikeAnimRate = 1
SWEP.StrikeTime = 0
SWEP.DmgType = 4
SWEP.MeleeRange = 0.1
SWEP.MeleeRange2 = 550
SWEP.CanParry = true

-- Blocking anim
SWEP.IronSights = true
SWEP.IronSightsPos = Vector(0, -8.643, 0.201)
SWEP.IronSightsAng = Vector(-30.8, 13.399, -70)

SWEP.GuardBlockAmount = 25

SWEP.HoldType = "melee2"
SWEP.GuardHoldType = "slam"

SWEP.ViewModel = "models/v_onehandedbegotten.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ShowWorldModel = false

-- Stamina counter
SWEP.SlotPos = 1
SWEP.DrawAmmo = true
SWEP.QuadAmmoCounter = true
SWEP.AmmoQuadColor = Color(255,0,0,255)

SWEP.BlockSound1 = Sound( "physics/metal/metal_canister_impact_hard1.wav" ) 
SWEP.BlockSound2 = Sound( "physics/metal/metal_canister_impact_hard3.wav" ) 
SWEP.ParrySound = Sound("WeaponFrag.Throw")

SWEP.ReloadSound = Sound("common/null.wav")

SWEP.Primary.Automatic = true

SWEP.HitDistance		= 55
SWEP.HitRate			= 0.70

-- Primary attack sounds
local SwingSound = Sound( "weapons/warhammer/skyrim_warhammer_swing1.mp3" )
local HitSoundBody = Sound( "weapons/mace/skyrim_mace_flesh1.mp3" )

function SWEP:OnDeploy()
	self.Owner:ViewPunch(Angle(2,0,2))
            self.Weapon:EmitSound("weapons/waraxe/skyrim_waraxe_draw1.mp3")    
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "draw" ) )
			
end



function SWEP:Hitscan()

//This function calculate the trajectory

	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * self.HitDistance * 1.5 ),
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )

//This if shot the bullets

	if ( tr.Hit ) then
	

		bullet = {}
		bullet.Num    = 1
		bullet.Src    = self.Owner:GetShootPos()
		bullet.Dir    = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = 5
		bullet.Hullsize = 0
		bullet.Distance = self.HitDistance * 1.5
		bullet.Damage = 22
		
		bullet.Callback = function(attacker, tr, dmginfo)
	dmginfo:SetDamageType(DMG_CLUB)
end
		
		self.Owner:FireBullets(bullet)

		self:EmitSound( SwingSound )

		//vm:SendViewModelMatchingSequence( vm:LookupSequence( "hitcenter1" ) )

		if tr.Entity:IsPlayer() or string.find(tr.Entity:GetClass(),"npc") or string.find(tr.Entity:GetClass(),"prop_ragdoll") then
			self:EmitSound( HitSoundBody )
				self.Owner:ViewPunch(Angle(-5,2,1))
		else
			self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(1, 3)..".wav");
				self.Owner:ViewPunch(Angle(-5,2,1))
		end

	
//if end
		//else vm:SendViewModelMatchingSequence( vm:LookupSequence( "misscenter1" ) )
		end

end
         

function SWEP:PrimaryAttack()

	-- Cannot swing if stamina is less than 5
	if self:Ammo1() < 5 then return end

	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	self.Owner:ViewPunch(Angle(1,0,0))
	
	-- Stamina taken for each swing
			self:TakePrimaryAmmo(5)

	local vm = self.Owner:GetViewModel()
	
	self:EmitSound( SwingSound )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.HitRate )

	vm:SendViewModelMatchingSequence( vm:LookupSequence( "misscenter1" ) )

	timer.Create("hitdelay", 0.05, 1, function() self:Hitscan() end)

	timer.Start( "hitdelay" )

end

function SWEP:OnRemove()

	timer.Remove("hitdelay")
	return true
end


/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()


	if self.Owner:KeyDown(IN_ATTACK2) and self.Owner:GetNWBool( "Guardening") == true then

            self.Weapon:EmitSound("cloth.wav") 
	self.Owner:ViewPunch(Angle(3,0,3))
			
end			

	if ( !self.IronSightsPos ) then return end
	if self.Owner:KeyDown(IN_ATTACK2) then return end
	if ( self.NextSecondaryAttack > CurTime() ) then return end
	if self.Owner:GetNWBool( "Guardening") == true then return end
	if self.Weapon:GetNWInt("Reloading") > CurTime() then return end
	if !self:CanSecondaryAttack() then return end

	
	--PARRY FUNCTION, PRETTY BUGGY
	if self:Ammo1() < 50 then return end
local wep = self.Weapon
local ply = self.Owner


self.NextSecondaryAttack = CurTime() + 1



local vm = self.Owner:GetViewModel()
vm:SendViewModelMatchingSequence( vm:LookupSequence( "misscenter1" ) )
self:EmitSound( self.ParrySound )

	local rnda = self.Primary.Recoil * 1
	local rndb = self.Primary.Recoil * math.random(-1, 1)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )	
		local fx 		= EffectData()
		
		fx:SetEntity(wep)
		fx:SetOrigin(ply:GetShootPos())
		fx:SetNormal(ply:GetAimVector())
		fx:SetAttachment("1")
		
		-- Stamina taken for each parry swing
		self:TakePrimaryAmmo(25)
		
		wep:SetNextPrimaryFire( CurTime() + 2 )
		self.Owner:SetNWBool( "Parry", true )
		
		-- Difficulty of parry success
timer.Simple( 0.1,function() if self:IsValid() and self.Owner:Alive() then

 self.Owner:SetNWBool( "Parry", false )
end end )
end

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(-0.186, 0.185, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(-0.926, 0.185, -0.186), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(-0.186, 0.185, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(-0.186, 0.555, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(-0.556, 0.555, -0.186), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(-0.186, 0.185, -0.186), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["v_baseballbat_metal"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/baseballbat.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 1.557, 8.831), angle = Angle(0, -92.338, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", "", skin = 10, bodygroup = { [1] = 3} },
	["quad"] = { type = "Quad", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-7.408, -72.594, -44.938), angle = Angle(-30, -118.889, -12.223), size = 0.2, draw_func = nil}
}

SWEP.WElements = {
	["w_baseballbat_metal"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/baseballbat.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.557, -0.519, 9.869), angle = Angle(10.519, -40.91, -180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 10, bodygroup = { [1] = 3} }
}
