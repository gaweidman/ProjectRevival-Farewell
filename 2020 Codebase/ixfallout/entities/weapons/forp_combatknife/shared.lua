SWEP.Base = "sword_swepbase"

if CLIENT then
SWEP.PrintName = L("Combat knife")
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
SWEP.IronSightsPos = Vector(-0.805, -17.889, 0)
SWEP.IronSightsAng = Vector(30.954, 0, 0)


SWEP.GuardBlockAmount = 100

SWEP.HoldType = "knife"
SWEP.GuardHoldType = "slam"

SWEP.ViewModel = "models/v_begottenknife.mdl"
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

SWEP.HitDistance		= 45
SWEP.HitRate			= 0.40

function SWEP:OnDeploy()
	self.Owner:ViewPunch(Angle(2,0,2))
            self.Weapon:EmitSound("weapons/dagger/skyrim_dagger_draw1.mp3")    
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
		bullet.Force  = 1
		bullet.Hullsize = 0
		bullet.Distance = self.HitDistance * 1.5
		-- bullet.Damage = 15
		bullet.Damage = 7
		
		bullet.Callback = function(attacker, tr, dmginfo)
	dmginfo:SetDamageType(DMG_CLUB)
end
		
		self.Owner:FireBullets(bullet)

		self:EmitSound("weapons/knife/knife_slash"..math.random(1, 2)..".wav");

		//vm:SendViewModelMatchingSequence( vm:LookupSequence( "hitcenter1" ) )

		if tr.Entity:IsPlayer() or string.find(tr.Entity:GetClass(),"npc") or string.find(tr.Entity:GetClass(),"prop_ragdoll") then
			self:EmitSound("weapons/knife/knife_hit"..math.random(1, 4)..".wav");
				self.Owner:ViewPunch(Angle(0,1,0))
		else
			self:EmitSound("weapons/knife/knife_hitwall1.wav");
				self.Owner:ViewPunch(Angle(0,1,0))
		end

	
//if end
		//else vm:SendViewModelMatchingSequence( vm:LookupSequence( "misscenter1" ) )
		end

end
         

function SWEP:PrimaryAttack()

	-- Cannot swing if stamina is less than 5
	if self:Ammo1() < 5 then return end

	self.Owner:SetAnimation( PLAYER_ATTACK1 )
		
	local vm = self.Owner:GetViewModel()
	
		self:EmitSound("weapons/knife/knife_slash"..math.random(1, 2)..".wav");
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
		self:TakePrimaryAmmo(50)
		
		wep:SetNextPrimaryFire( CurTime() + 2 )
		self.Owner:SetNWBool( "Parry", true )
		
		-- Difficulty of parry success
timer.Simple( 0.08,function() if self:IsValid() and self.Owner:Alive() then

 self.Owner:SetNWBool( "Parry", false )
end end )
end

SWEP.VElements = {
	["v_combatknife"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/knife.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 1.557, 5.714), angle = Angle(0, -115.714, 180), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["quad"] = { type = "Quad", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-22.223, -80, -50.864), angle = Angle(-143.333, 63.333, 165.555), size = 0.2, draw_func = nil}
}


SWEP.WElements = {
	["w_combatknife"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/knife.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 0.518, 3.635), angle = Angle(5.843, -73.637, 174.156), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}