AddCSLuaFile()

SWEP.HoldType           = "grenade"

SWEP.HoldReady             = "grenade"
SWEP.HoldNormal            = "slam"

if CLIENT then
   SWEP.PrintName       = "Smoke Grenade"
   SWEP.Slot            = 3

   SWEP.ViewModelFlip   = false
   SWEP.ViewModelFOV    = 54

   SWEP.Icon            = "vgui/ttt/icon_nades"
   SWEP.IconLetter      = "Q"
end

SWEP.UseHands           = true
SWEP.ViewModel          = "models/weapons/cstrike/c_eq_smokegrenade.mdl"
SWEP.WorldModel         = "models/weapons/w_eq_smokegrenade.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "grenade"
SWEP.Primary.Damage = 0
SWEP.Primary.Delay = 0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "grenade"
SWEP.Secondary.Damage = 0
SWEP.Secondary.Delay = 0


SWEP.Weight             = 5
SWEP.AutoSpawnable      = true
SWEP.Spawnable          = true

SWEP.detonate_timer        = 5

-- really the only difference between grenade weapons: the model and the thrown
-- ent.

function SWEP:GetGrenadeName()
   return "ttt_smokegrenade_proj"
end

AccessorFunc(SWEP, "det_time", "DetTime")

function SWEP:SetupDataTables()
   self:NetworkVar("Bool", 0, "Pin")
   self:NetworkVar("Int", 0, "ThrowTime")
end

function SWEP:PrimaryAttack()
   self:PullPin()
end

function SWEP:SecondaryAttack()
end

function SWEP:PullPin()
   if self:GetPin() then return end

   local ply = self:GetOwner()
   if not IsValid(ply) then return end

   self:SendWeaponAnim(ACT_VM_PULLPIN)

   if self.SetHoldType then
      self:SetHoldType(self.HoldReady)
   end

   self:SetPin(true)

   self:SetDetTime(CurTime() + self.detonate_timer)
end


function SWEP:Think()
   local ply = self:GetOwner()
   if not IsValid(ply) then return end

   -- pin pulled and attack loose = throw
   if self:GetPin() then
      -- we will throw now
      if not ply:KeyDown(IN_ATTACK) then
         self:StartThrow()

         self:SetPin(false)
         self:SendWeaponAnim(ACT_VM_THROW)

         if SERVER then
            self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
         end
      else
         -- still cooking it, see if our time is up
         if SERVER and self:GetDetTime() < CurTime() then
            --self:BlowInFace()
         end
      end
   elseif self:GetThrowTime() > 0 and self:GetThrowTime() < CurTime() then
      
      self:Throw()
   end
end


function SWEP:BlowInFace()
   local ply = self:GetOwner()
   if not IsValid(ply) then return end

   if self.was_thrown then return end

   self.was_thrown = true

   -- drop the grenade so it can immediately explode

   local ang = ply:GetAngles()
   local src = ply:GetPos() + (ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset())
   src = src + (ang:Right() * 10)

   self:CreateGrenade(src, Angle(0,0,0), Vector(0,0,1), Vector(0,0,1), ply)

   self:SetThrowTime(0)
   self:Remove()
end

function SWEP:StartThrow()
   self:SetThrowTime(CurTime() + 0.1)
end

function SWEP:Throw()
   if CLIENT then
      self:SetThrowTime(0)
   elseif SERVER then
      local ply = self:GetOwner()
      if not IsValid(ply) then return end

      if self.was_thrown then return end

      self.was_thrown = true

      local ang = ply:EyeAngles()
      local src = ply:GetPos() + (ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset())+ (ang:Forward() * 8) + (ang:Right() * 10)
      local target = ply:GetEyeTraceNoCursor().HitPos
      local tang = (target-src):Angle() -- A target angle to actually throw the grenade to the crosshair instead of fowards
      -- Makes the grenade go upgwards
      if tang.p < 90 then
         tang.p = -10 + tang.p * ((90 + 10) / 90)
      else
         tang.p = 360 - tang.p
         tang.p = -10 + tang.p * -((90 + 10) / 90)
      end
      tang.p=math.Clamp(tang.p,-90,90) -- Makes the grenade not go backwards :/
      local vel = math.min(800, (90 - tang.p) * 6)
      local thr = tang:Forward() * vel + ply:GetVelocity()
      self:CreateGrenade(src, Angle(0,0,0), thr, Vector(600, math.random(-1200, 1200), 0), ply)

      self:SetThrowTime(0)
      self:Remove()
   end
end

function SWEP:CreateGrenade(src, ang, vel, angimp, ply)
   local gren = ents.Create(self:GetGrenadeName())
   if not IsValid(gren) then return end

   gren:SetPos(src)
   gren:SetAngles(ang)

   --   gren:SetVelocity(vel)
   gren:SetOwner(ply)
   gren:SetThrower(ply)

   gren:SetGravity(0.4)
   gren:SetFriction(0.2)
   gren:SetElasticity(0.45)

   gren:Spawn()

   gren:PhysWake()

   local phys = gren:GetPhysicsObject()
   if IsValid(phys) then
      phys:SetVelocity(vel)
      phys:AddAngleVelocity(angimp)
   end

   -- This has to happen AFTER Spawn() calls gren's Initialize()
   gren:SetDetonateExact(CurTime() + self.detonate_timer)

   return gren
end

function SWEP:PreDrop()
   -- if owner dies or drops us while the pin has been pulled, create the armed
   -- grenade anyway
   if self:GetPin() then
      --self:BlowInFace()
   end
end

function SWEP:Deploy()

   if self.SetHoldType then
      self:SetHoldType(self.HoldNormal)
   end

   self:SetThrowTime(0)
   self:SetPin(false)
   return true
end

function SWEP:Holster()
   if self:GetPin() then
      return false -- no switching after pulling pin
   end

   self:SetThrowTime(0)
   self:SetPin(false)
   return true
end

function SWEP:Reload()
   return false
end

function SWEP:Initialize()
   if self.SetHoldType then
      self:SetHoldType(self.HoldNormal)
   end

   self:SetDeploySpeed(self.DeploySpeed)

   self:SetDetTime(0)
   self:SetThrowTime(0)
   self:SetPin(false)

   self.was_thrown = false
end
