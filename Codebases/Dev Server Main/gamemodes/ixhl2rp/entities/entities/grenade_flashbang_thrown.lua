AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Thrown Flashbang"
ENT.Category = "HL2 RP"
ENT.Spawnable = false
ENT.AdminOnly = true

if (SERVER) then
	function ENT:Initialize()

       
		self:SetModel("models/weapons/w_eq_flashbang_thrown.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

        self:SetVar("explodeTime", CurTime() + 2)
	end	

    function ENT:PhysicsCollide( data, phys )
	    if ( data.Speed > 50 ) then self:EmitSound( Sound( "Flashbang.Bounce" ) ) end
    end

    function ENT:Think()
        if self:GetVar("explodeTime") <= CurTime() then
            self:Explode()
        end
    end

    function ENT:Explode()  
        local effectData = EffectData()
        effectData:SetOrigin(self:GetPos())
        if self:WaterLevel() != 0 then
            util.Effect("WaterSurfaceExplosion", effectData)
        else
            util.Effect("HelicopterMegaBomb", effectData)
        end

        self:EmitSound("weapons/flashbang/flashbang_explode"..math.random(1, 2)..".wav")
        for k, v in ipairs(player.GetAll()) do
            if v:GetPos():Distance(self:GetPos()) <= 150 then
                v:ScreenFade(SCREENFADE.IN, Color(255, 255, 255, 255), 1, 6)
                v:SetDSP(32)
            end
        end

        self:Remove()
    end

elseif (CLIENT) then

end