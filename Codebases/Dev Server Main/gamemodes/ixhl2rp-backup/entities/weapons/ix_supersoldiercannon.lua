AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName = "Super Soldier Handcannon"
	SWEP.Slot = 0
	SWEP.SlotPos = 5
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Category = "HL2 RP"
SWEP.Author = "QIncarnate"
SWEP.Instructions = "Primary Fire: Stun.\nALT + Primary Fire: Toggle stun.\nSecondary Fire: Push/Knock.\nReload: Change Voltage"
SWEP.Purpose = "Hitting things and knocking on doors."
SWEP.Drop = false

SWEP.HoldType = "pistol"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV		= 60	
SWEP.ViewModel = Model("models/weapons/c_suppressor.mdl")
SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl")
SWEP.AnimPrefix	 = "melee"

SWEP.Primary.ClipSize = 50
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.Damage = 5
SWEP.Primary.Delay = 0.5

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""


SWEP.UseHands = false
SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.FireWhenLowered = true

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if (CLIENT) then return end
	if (self.Weapon:Clip1() > 0) then
		self.Owner:EmitSound("weapons/ar2/fire1.wav")
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	else
		self.Owner:EmitSound("weapons/ar2/ar2_empty.wav")
	end
end

function SWEP:Reload()
	if CurTime() <= self.ReloadingTime then return end
	if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then return end
	self.Weapon:DefaultReload(ACT_VM_RELOAD)
	self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())

	self.ReloadingTime = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end