AddCSLuaFile()
PrecacheParticleSystem("vortigaunt_charge_token")

ENT.Type = "anim"
ENT.PrintName = "Vortigaunt Light"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.PhysgunDisabled = false
ENT.bNoPersist = true

    function ENT:Initialize()
        
        self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:DrawShadow(false)

        --ParticleEffect("vortigaunt_charge_token", self:GetPos(), Angle(0, 0, 0), self)
        ParticleEffectAttach("vortigaunt_hand_glow", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("static_prop"))
        self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
        if SERVER then
            self:SetNetVar("createTime", CurTime())
        end
    end

    function ENT:Use( ply, caller )

    end


if CLIENT then

    function ENT:Draw()
        --self:DrawModel()
    end


    function ENT:OnRemove()
        timer.Simple( 0, function()
		if not IsValid( self ) then
			local dlight = DynamicLight(self:EntIndex())
            dlight.DieTime = CurTime() + 10
		end
	end)
    end
end

if SERVER then
    function ENT:SetCustomParent(entIndex)
        self:SetNetVar("parent", entIndex)
    end
end


function ENT:Think()
    local parentEntIndex = self:GetNetVar("parent")
    if parentEntIndex != nil then
        local parent = Entity(parentEntIndex)
        local lightPos = nil


        local boneID = parent:LookupBone("ValveBiped.bone4")
        bonePos = parent:GetBonePosition(boneID)
        local boneMatrix = parent:GetBoneMatrix(boneID)

        if boneMatrix != nil then -- This check makes sure the player isn't entering or leaving noclip/observer
            -- It's not the cleanest fix but it works like a charm.
            if bonePos == parent:GetPos() then
                bonePos = boneMatrix:GetTranslation()
            end 
            self.pos = self.pos or bonePos
            self.projPos = bonePos

            self.pos = Lerp( 1, self.pos, self.projPos )
            self:SetPos( self.pos + Vector(0, 0, 2))
            lightpos = self.pos
        else
            self.pos = self.pos or parent:GetPos()
            self.projPos = parent:GetPos()

            self.pos = Lerp( 1, self.pos, self.projPos )
            self:SetPos( self.pos + Vector(0, 0, 40))
            lightpos = self.pos 
        end
    
        if CLIENT then
            local dlight = DynamicLight( self:EntIndex() )
            local createTime = self:GetNetVar("createTime")
            local curTime = CurTime()
            if ( dlight ) then
                dlight.pos = self:GetPos()

                dlight.r = 47
                dlight.g = 255
                dlight.b = 105
                dlight.brightness = Lerp((curTime - createTime)/0.4 + 0.1, -12, 1 )
                dlight.Decay = 1000 / 4
                dlight.Size = 200
                dlight.DieTime = CurTime() + 9999999
            end
        end
    end
end
