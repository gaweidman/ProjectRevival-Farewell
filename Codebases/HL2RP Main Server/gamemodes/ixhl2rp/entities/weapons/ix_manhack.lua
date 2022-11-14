SWEP.PrintName = "Manhack"
SWEP.Category = "QIncarnate Weapons"
SWEP.Author = "QIncarnate"
SWEP.Instructions = "Left click to throw."
SWEP.Purpose = "Flashing things and banging things."
SWEP.Drop = false

SWEP.HoldType = "normal"

SWEP.Spawnable = true

SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV		= 57
SWEP.ViewModel = Model("models/weapons/v_manhackcontrol.mdl")
SWEP.WorldModel = Model("models/manhack.mdl")

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
end

function SWEP:PrimaryAttack()
    if !IsFirstTimePredicted() then return end
    if !self:CanPrimaryAttack() then return end

    if SERVER then

        local owner = self:GetOwner()
        local wep = self

        owner:SetNetVar("IsThrowing", true)

        self:GetOwner():ForceSequence("deploy")

        owner:SetBodygroup(owner:FindBodygroupByName("manhack"), 1)

        local manhack = self.manhack

        timer.Simple(0.2, function()
            if IsValid(wep.manhack) then
                wep.manhack:Remove()
            end

            owner:GetViewModel():SetNoDraw(true)

            owner:SetBodygroup(owner:FindBodygroupByName("manhack"), 0)
            wep.manhack = ents.Create("prop_dynamic")
            local bone = owner:LookupBone("ValveBiped.Anim_Attachment_RH")
            local bonePos, boneAng = owner:GetBonePosition(bone)
            local attPos = owner:GetAttachment(4).Pos
            wep.manhack:SetPos(attPos)
            wep.manhack:SetAngles(boneAng)
            wep.manhack:SetModel("models/manhack.mdl")
            wep.manhack:SetModelScale(0.75)
            wep.manhack:Spawn()
            wep.manhack:SetParent(owner, 4)

            wep.manhack.Draw = function()
                local ply = LocalPlayer()
                if ply:GetViewEntity() != ply then
                    self:DrawModel()
                end
            end
            
        end)

        timer.Simple(1.1, function()
            if IsValid(wep.manhack) then
                wep.manhack:Remove()
            end

            local manhack = ents.Create("npc_manhack")
            manhack:SetPos(owner:GetAttachment(4).Pos)
            manhack:SetAngles(angle_zero)
            manhack:Spawn()

            undo.Create("Manhack")
                undo.AddEntity(manhack)
                undo.SetPlayer(owner)
            undo.Finish()

            owner:SetNetVar("IsThrowing", false)

            local item = owner:GetCharacter():GetInventory():HasItem("manhack")
            item:Remove()

            wep:Remove()

            if owner:GetCharacter():GetInventory():HasItem("manhack") then
                owner:Give("ix_manhack")
            end
        end)
        
    end
end

function SWEP:CanPrimaryAttack()
    return !self:GetOwner():GetNetVar("IsThrowing", false)
end

function SWEP:SecondaryAttack()

end

function SWEP:Holster(weapon)
    return !weapon:GetOwner():GetNetVar("IsThrowing", false)
end

function SWEP:DrawWorldModel(flags)
    if self:GetNetVar("DrawWorldModel", false) then
        self:DrawModel(flags)
    end
end