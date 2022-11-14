SWEP.HoldType = "smg"
if SERVER then
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = true
	SWEP.AutoSwitchFrom = true
	SWEP.NPCFireRate = 3.5
	SWEP.tblSounds = {}
	SWEP.tblSounds["Off"] = "weapons/egon/egon_off1.wav"
	
	local function CreateWorldModel(self)
		local entModel = ents.Create("prop_dynamic_override")
		entModel:SetModel("models/weapons/half-life/w_egon.mdl")
		entModel:SetPos(self:GetPos())
		entModel:SetAngles(self:GetAngles())
		entModel:SetParent(self)
		entModel:Spawn()
		entModel:Activate()
		self.entModel = entModel
	end
	
	function SWEP:PostInit()
		if IsValid(self.Owner) then return end
		CreateWorldModel(self)
		self:SetColor(255,255,255,0)
		self:DrawShadow(false)
	end
	
	function SWEP:OnRemove()
		if IsValid(self.entModel) then
			self.entModel:Remove()
		end
	end
	
	function SWEP:OnEquip()
		if IsValid(self.entModel) then
			self.entModel:Remove()
			self:SetColor(255,255,255,255)
			self:DrawShadow(true)
		end
	end
	
	function SWEP:OnDrop()
		self:Drop()
		CreateWorldModel(self)
	end
end

if CLIENT then
	SWEP.CSMuzzleFlashes = true
end

SWEP.Base = "weapon_slv_base"
SWEP.Category		= "SLVBase - Half-Life Renaissance"
SWEP.PrintName = "Plasma Immolator"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/v_cremator.mdl"
--SWEP.WorldModel = "models/weapons/half-life/p_egon.mdl"
SWEP.InWater = false

SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 100
SWEP.Primary.Automatic = false
SWEP.Primary.SingleClip = true
SWEP.Primary.Ammo = "uranium"
SWEP.Primary.AmmoSize = 100
SWEP.Primary.AmmoPickup	= 100
SWEP.Primary.Delay = 0.2

SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.AmmoSize = -1
SWEP.Secondary.Delay = 1

function SWEP:CustomIdle()
	local act
	if self.bInAttack then act = ACT_VM_PRIMARYATTACK
	else act = ACT_VM_IDLE end
	self.Weapon:SendWeaponAnim(act)
	self:NextIdle(self:SequenceDuration())
end

function SWEP:EndAttack()
	if !self.bInAttack then return end
	self.Weapon:SetNextSecondaryFire(CurTime() +self.Primary.Delay)
	self.Weapon:SetNextPrimaryFire(CurTime() +self.Primary.Delay)
	self.bInAttack = false
	self:NextIdle(0)
	if CLIENT then return end
	if IsValid(self.entBeam) then self.entBeam:Remove() end
	self:slvPlaySound("Off")
	if self.cspWindup then self.cspWindup:Stop() end
end

function SWEP:OnThink()
	if !self.bInAttack then return end
	if CurTime() < self.nextDrain then return end
	if !IsValid(self.Owner) || (!self.Owner:KeyDown(IN_ATTACK) && !self.Owner:KeyDown(IN_ATTACK2)) || self:GetAmmoPrimary() <= 0 then self:EndAttack(); return end
	self.nextDrain = CurTime() +0.1
	self:PlayThirdPersonAnim()
	if CLIENT then return end
	local tr = util.TraceLine(util.GetPlayerTrace(self.Owner))
	if tr.Entity and IsValid(tr.Entity) and !tr.Entity:IsPlayer() and !tr.Entity:IsWorld() then 
		local dmgInfo = DamageInfo()
		dmgInfo:SetDamageType(DMG_DISSOLVE)
		dmgInfo:SetDamage(100)
		dmgInfo:SetAttacker(self.Owner)
		dmgInfo:SetInflictor(self)
		tr.Entity:TakeDamageInfo(dmgInfo)
	end
end

function SWEP:PrimaryAttack()
	if self.bInAttack then self:EndAttack(); return end
	if false then return end
	self.bInAttack = true
	self:NextIdle(0)
	self.nextDrain = 0
	if SERVER then
		self.cspWindup = CreateSound(self.Owner,"weapons/egon/egon_run1.wav")
		self.cspWindup:Play()
		self:slvPlaySound("WindUp")
		local entBeam = ents.Create("obj_beam_egon")
		entBeam:SetPos(self.Owner:GetShootPos())
		entBeam:Spawn()
		entBeam:SetParent(self.Owner)
		entBeam:SetOwner(self.Owner)
		self.entBeam = entBeam
	end
end

function SWEP:OnRemove()
	self:EndAttack()
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end

function SWEP:OnHolster()
	self:EndAttack()
end

function SWEP:DrawWorldModel()
	/*
	local ply = self:GetOwner()

	if !IsValid(ply) then
		-- No one is holding the weapon, draw it regularly and bail
		self:DrawModel()
		return
	end

	if !self.flameThrowerHand then
		self.flameThrowerHand = ply:LookupAttachment("anim_attachment_rh")
	end

	local handData = ply:GetAttachment(self.flameThrowerHand)

	if !handData then
		-- We don't have our data for some reason, draw and bail
		self:DrawModel()
		return
	else
		-- We have our data, proceed as normal
		local ang = handData.Ang
		local pos = handData.Pos
			+ ang:Forward() * 11
			+ ang:Right() * 0.3
			+ ang:Up() * -7

		self:SetRenderOrigin(pos)
		self:SetRenderAngles(ang)
		self:DrawModel()
	end
	*/
end