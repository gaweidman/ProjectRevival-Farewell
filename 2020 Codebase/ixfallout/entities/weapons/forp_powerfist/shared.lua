SWEP.Base = "sword_swepbase"

if CLIENT then
SWEP.PrintName = L"Power fist"
SWEP.Instructions = L"Primary Fire: Attack.\nSecondary Fire: Guard."
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
SWEP.CanParry = false

-- Blocking anim
SWEP.IronSights = true
SWEP.IronSightsPos = Vector(0, -5, 0)
SWEP.IronSightsAng = Vector(20, 0, 0)


SWEP.GuardBlockAmount = 25

SWEP.HoldType = "fist"
SWEP.GuardHoldType = "melee2"

SWEP.ViewModel = "models/weapons/v_punchy.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ShowWorldModel = false

-- Stamina counter
SWEP.SlotPos = 1
SWEP.DrawAmmo = true
SWEP.QuadAmmoCounter = true
SWEP.AmmoQuadColor = Color(255,0,0,255)

SWEP.BlockSound1 = Sound( "weapons/greatsword/skyrim_greatsword_hitwall2.mp3" ) 
SWEP.BlockSound2 = Sound( "weapons/sword/skyrim_sword_hitwall2.mp3" ) 
SWEP.ParrySound = Sound("WeaponFrag.Throw")

SWEP.ReloadSound = Sound("common/null.wav")

SWEP.Primary.Automatic = true

SWEP.HitDistance		= 50
SWEP.HitRate			= 0.55

-- Primary attack sounds
local SwingSound = Sound( "weapons/mace/skyrim_mace_swing1.mp3" )
local HitSoundBody = Sound( "weapons/warhammer/skyrim_warhammer_flesh1.mp3" )

function SWEP:OnDeploy()
	self.Owner:ViewPunch(Angle(3,0,3))
            self.Weapon:EmitSound("weapons/warhammer/skyrim_warhammer_draw1.mp3")    
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
		bullet.Force  = 30
		bullet.Hullsize = 0
		bullet.Distance = self.HitDistance * 1.5
		-- bullet.Damage = 40
		bullet.Damage = 20
		
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
			self:EmitSound("weapons/warhammer/skyrim_warhammer_hitwall2.mp3");
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
	
	self.Owner:ViewPunch(Angle(0,10,0))
	
	-- Stamina taken for each swing
			self:TakePrimaryAmmo(5)

	local vm = self.Owner:GetViewModel()
	
	self:EmitSound( SwingSound )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.HitRate )

			vm:SetSequence(vm:LookupSequence("punchmiss1"))
			timer.Simple( 0.2,function() if self:IsValid() and self.Owner:Alive() then 
			self:SendWeaponAnim(ACT_VM_IDLE) end end)
			
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
		self:TakePrimaryAmmo(15)
		
		wep:SetNextPrimaryFire( CurTime() + 2 )
		self.Owner:SetNWBool( "Parry", true )
		
		-- Difficulty of parry success
timer.Simple( 0.08,function() if self:IsValid() and self.Owner:Alive() then

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
	["quad"] = { type = "Quad", bone = "r-forearm", rel = "", pos = Vector(4.443, -80, 6.42), angle = Angle(-163.333, 18.888, 112.222), size = 0.2, draw_func = nil},
	["v_powerfist"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/powerfist.mdl", bone = "r-rist", rel = "", pos = Vector(-3.5, -0, -0.519), angle = Angle(1.169, -97.014, -90), size = Vector(0.79, 0.79, 0.79), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["v_powerfist"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/powerfist.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-9.87, -1.558, 0.518), angle = Angle(-180, 82.986, 87.662), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}