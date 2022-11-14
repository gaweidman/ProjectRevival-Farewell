ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.PrintName = "Garbage"
ENT.Author = "Bilwin"
ENT.Category = "Garbage"
ENT.Spawnable = true
ENT.AdminOnly = true

-- Random Use sounds
local pickup_sound = {
    "physics/cardboard/cardboard_box_impact_hard5.wav",
    "physics/cardboard/cardboard_box_impact_hard6.wav",
    "physics/cardboard/cardboard_box_impact_hard7.wav"
}

if (SERVER) then
    function ENT:Initialize()
	    self:SetModel("models/props_junk/garbage128_composite001c.mdl") -- Entity model
	    self:SetSolid(SOLID_VPHYSICS)
	    self:SetUseType(SIMPLE_USE)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)

        local phys = self:GetPhysicsObject()
        if (phys:IsValid()) then
            phys:Wake()
        end
    end

    function ENT:Use(activator, caller)
        if IsValid(activator) and activator:IsPlayer() and activator:GetCharacter() then        
            if (activator.GarbageLoot or 0) > CurTime() then
                return;
            end

            if (self.NextSearch or 0) > CurTime() then
                return;
            end

            if activator:Crouching() then
                caller:EmitSound(pickup_sound[math.random(1, #pickup_sound)], 75, 100, 1, CHAN_AUTO)
 
                activator:SetAction("Searching...", 10)
                activator:DoStaredAction(self, function()
                    if ( IsValid(activator) ) then
                        if (self.NextSearch or 0) > CurTime() then
                            activator:Notify('Nothing')
                            return;
                        end

                        for k, v in ipairs(GarbageLoot.config) do
                            if (100 * math.random() > GarbageLoot.config["chance"]) then
                                activator:Notify('Nothing')
                                break
                            end
        
                            activator:Notify('You found something')
                            activator:GetCharacter():GetInventory():Add(table.Random(GarbageLoot.config["items"]), 1)
                            break
                        end

                        self:SetNoDraw(true);

                        timer.Simple(800, function()
                            self:SetNoDraw(false);
                        end)

                        self.NextSearch = CurTime() + 800
                    end
                end, 10, function()
                    if IsValid(activator) then
                        if not activator:Crouching() then
                            activator:SetAction()
                        end
                        activator:SetAction()
                    end
                end)
            end

            activator.GarbageLoot = CurTime() + 2
        end
	end

	function ENT:UpdateTransmitState()
		return TRANSMIT_PVS
	end
else
    function ENT:Draw()
	    self:DrawModel()
    end
end