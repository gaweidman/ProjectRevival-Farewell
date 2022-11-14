AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName = "Flashbang"
	SWEP.Slot = 0
	SWEP.SlotPos = 5
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Category = "QIncarnate Weapons"
SWEP.Author = "QIncarnate"
SWEP.Instructions = "Left click to throw."
SWEP.Purpose = "Flashing things and banging things."
SWEP.Drop = false

SWEP.HoldType = "melee"

SWEP.Spawnable = true

SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV		= 57
SWEP.ViewModel = Model("models/weapons/cstrike/c_eq_flashbang.mdl")
SWEP.WorldModel = Model("models/weapons/w_eq_flashbang.mdl")

SWEP.HoldType = "grenade"

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

SWEP.UseHands = true

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
    self:SetVar("throwing", false)
end

function SWEP:PrimaryAttack()
    if !IsFirstTimePredicted() then return end
    if !self:CanPrimaryAttack() then return end
    self:SetVar("throwing", true)
    self:ThrowAnim()
end

function SWEP:CanPrimaryAttack()
    return !self:GetVar("throwing", false)
end

function SWEP:SecondaryAttack()

end

function SWEP:Holster(weapon)
    self:SetVar("throwTime", nil)
    self:SetVar("throwing", false)

    if (self:GetVar("deleteTime", nil) != nil and (SERVER)) then
        self:Remove()
    end

    return true
end

function SWEP:ThrowAnim()
    local viewModel = self.Owner:GetViewModel()
    local animVersion = math.random(1, 4)
    if (animVersion == 1) then
        animVersion = "pullpin"
    else
        animVersion = "pullpin" .. animVersion
    end
    local sequenceID, length = viewModel:LookupSequence( animVersion )
    viewModel:SendViewModelMatchingSequence( sequenceID ) 
    --self:SetVar("throwTime", CurTime() + length)
    self:SetVar("throwTime", CurTime() + 0.1)
end

function SWEP:Think()
    local viewModel = self.Owner:GetViewModel()
    
    if self:GetVar("throwTime", nil) != nil and self:GetVar("throwTime") <= CurTime() and self:GetVar("throwing", false) then
        if not self.Owner:KeyDown(IN_ATTACK) then
            local sequenceID, length = viewModel:LookupSequence( "throw" )
            viewModel:SendViewModelMatchingSequence(sequenceID)
            self:SetVar("throwTime", nil) 
            self:SetVar("deleteTime", CurTime() + length)

            local owner = self:GetOwner()

            owner:DoAttackEvent()

            -- Make sure the weapon is being held before trying to throw a chair
            if ( not owner:IsValid() ) then return end

            -- Play the shoot sound we precached earlier!
        
            -- If we're the client then this is as much as we want to do.
            -- We play the sound above on the client due to prediction.
            -- ( if we didn't they would feel a ping delay during multiplayer )
            if ( CLIENT ) then return end

            -- Create a prop_physics entity
            local ent = ents.Create( "grenade_flashbang_thrown")

            -- Always make sure that created entities are actually created!
            if ( not ent:IsValid() ) then return end

            -- Set the entity's model to the passed in model

            -- This is the same as owner:EyePos() + (self.Owner:GetAimVector() * 16)
            -- but the vector methods prevent duplicitous objects from being created
            -- which is faster and more memory efficient
            -- AimVector is not directly modified as it is used again later in the function
            local aimvec = owner:GetAimVector()
            local pos = aimvec * 16 -- This creates a new vector object
            pos:Add( owner:EyePos() ) -- This translates the local aimvector to world coordinates
            pos:Add(Vector(0, 0, -5))

            -- Set the position to the player's eye position plus 16 units forward.
            ent:SetPos( pos )

            -- Set the angles to the player'e eye angles. Then spawn it.
            ent:SetAngles( owner:EyeAngles() )
            ent:Spawn()
        
            -- Now get the physics object. Whenever we get a physics object
            -- we need to test to make sure its valid before using it.
            -- If it isn't then we'll remove the entity.
            local phys = ent:GetPhysicsObject()
            if ( not phys:IsValid() ) then ent:Remove() return end
        
            -- Now we apply the force - so the chair actually throws instead 
            -- of just falling to the ground. You can play with this value here
            -- to adjust how fast we throw it.
            -- Now that this is the last use of the aimvector vector we created,
            -- we can directly modify it instead of creating another copy
            aimvec:Mul( 3000 )
            aimvec:Add( VectorRand( -10, 10 ) ) -- Add a random vector with elements [-10, 10)
            phys:ApplyForceCenter( aimvec )

            self:Remove()
        end
    
    elseif self:GetVar("deleteTime", nil) != nil and self:GetVar("deleteTime") <= CurTime() and self:GetVar("throwing", false) then
        if (SERVER) then
            self:Remove()
        end
    end
end