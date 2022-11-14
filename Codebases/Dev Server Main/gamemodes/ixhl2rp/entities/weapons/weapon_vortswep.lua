AddCSLuaFile()
PrecacheParticleSystem("vortigaunt_charge_token")
PrecacheParticleSystem("vortigaunt_beam_charge")
PrecacheParticleSystem("vortigaunt_beam")
PrecacheParticleSystem("vortigaunt_hand_glow")

util.PrecacheModel("models/vortigaunt.mdl")
util.PrecacheModel("models/vortigaunt_slave.mdl")
util.PrecacheModel("models/vortigaunt_blue.mdl")
util.PrecacheModel("models/vortigaunt_doctor.mdl")

-- vort title enums 
VORT_DISCONNECTED = -1

VORT_NOVICE = 1
VORT_APPRENTICE = 2
VORT_ADEPT = 3
VORT_MASTER = 4
VORT_ELDER = 5
VORT_TRANSCENDANT = 6

-- claw enums
CLAWS_LEFT = 1
CLAWS_RIGHT = 2
CLAWS_BOTH = 3

ACT_ANTLION_FLIP = 2121
SCHED_ANTLION_FLIP = 217
COND_ANTLION_FLIPPED = 71

if (CLIENT) then
	SWEP.PrintName = "Vortigaunt SWEP"
	SWEP.Slot = 0
	SWEP.SlotPos = 5
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
    util.PrecacheModel("models/props_junk/metal_paintcan001a.mdl")
end

SWEP.Category = "QIncarnate Weapons"
SWEP.Author = "QIncarnate"
SWEP.Instructions = "Left click to throw."
SWEP.Purpose = "Flashing things and banging things."
SWEP.Drop = false

SWEP.Spawnable = true

SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV		= 90
SWEP.ViewModel = Model("models/weapons/c_crowbar.mdl")
SWEP.UseHands = true

SWEP.HoldType = "normal"
SWEP.DrawCrosshair = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = nil
SWEP.Primary.Damage = 0
SWEP.Primary.Delay = 0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = nil
SWEP.Secondary.Damage = 0
SWEP.Secondary.Delay = 0

-- SWEP Constants
do
    -- Damage
    SWEP.ZAPDAMAGE = 9999999
    SWEP.STOMPDAMAGE = 40
    SWEP.QUICKZAPDAMAGE = 10
    SWEP.MELEEDAMAGECLUB = 5
    SWEP.MELEEDAMAGESHOCK = 15
    
    -- Forces
    SWEP.ZAPFORCE = 20000
    SWEP.STOMPFORCE = 30000
    SWEP.QUICKZAPFORCE = 1500

    -- Timing
    SWEP.STUNTIME = 3
    SWEP.SHOWZAPBEAMTIME = 1.43

    -- Vortessence
    SWEP.MAXVORTESSENCE = 200

    -- Vortessence Consumption
    SWEP.ZAPCONSUMP = 25
    SWEP.STOMPCONSUMP = 30
    SWEP.QUICKZAPCONSUMP = 10
    SWEP.STUNCONSUMP = 10
    SWEP.VORTALEYECONSUMP = 1 -- Per Second Rate
    SWEP.VORTILAMPSTARTCONSUMP = 1
    SWEP.VORTILAMPCONSUMPRATE = 2 -- Per Second Rate
    SWEP.SWINGCONSUMP = 10

    -- HUD Constants
    SWEP.BARWIDTH = 50
    SWEP.XMARGIN = 50
    SWEP.YMARGIN = 50
    SWEP.TEXTMARGIN = 25
    SWEP.ANIMDURATION = 0.5    -- This one is pretty ambiguous by the name, but it means the length of time it takes for vortessence increase or decrease animations to play.
    --So at CurTime() + self.ANIMDURATION, the animation is done.

    -- Form Enhancement
    BASEENHANCEDRUNSPEED = 300

    -- Attack sounds
    SWEP.ATTACKSOUNDS = {
        {"vo/npc/vortigaunt/passon.wav", "Pass on!"},
        {"vo/npc/vortigaunt/nodenexus.wav", "Node and nexus, feed upon this life!"},
        {"vo/npc/vortigaunt/returntoall.wav", "Return to the all in one!"},
        {"vo/npc/vortigaunt/returnvoid.wav", "Return to the void!"},
        {"vo/npc/vortigaunt/surge.wav", "We surge!"},
        {"vo/npc/vortigaunt/tothevoid.wav", "To the void with you!"},
        {"vo/npc/vortigaunt/vort_attack21.wav", "Karrah!"}
    }

    SWEP.INORGANICNPCS = {
        "models/combine_camera/combine_camera.mdl",
        "models/manhack.mdl",
        "models/combine_scanner.mdl",
        "models/roller.mdl",
        "models/roller_spikes.mdl",
        "models/roller_vehicledriver.mdl",
        "models/combine_turrets/floor_turret.mdl",
        "models/combine_turrets/ceiling_turret.mdl"
    }
end

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
    if !IsFirstTimePredicted() then return end
    if !self:CanPrimaryAttack() then return end

    local owner = self:GetOwner()
    local char = owner:GetCharacter()
    local viewmodel = owner:GetViewModel()

    if self:GetVar("WeaponMode", "Ranged") == "Ranged" then
        if (owner:KeyDown(IN_WALK)) then
            self:SetVar("IsAttacking", true)
            self:SetVar("Attack", "Stomp")


            owner:StopParticles()
            
            ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("rightclaw"))
            ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("leftclaw"))
            
            self:SetVar("handParticleTimer", CurTime() + 1)

            local sequenceID, length = owner:LookupSequence("dispel")
            
            if SERVER then
                owner:ForceSequence("dispel", nil, nil, true)
                self:StartChargebeams()
            end

            timer.Simple(length*(0.78-0.57), function() -- The sound doesn't seem right when it plays, so we delay it by a little.
                self:EmitSound("npc/vort/vort_dispell.wav")
            end) 

            self:SetVar("AnimTime", CurTime() + length*0.78)
        else
            self:SetVar("IsAttacking", true)
            self:SetVar("Attack", "Zap")

            local seqID, length = viewmodel:LookupSequence("zapattack1")
            viewmodel:SetPlaybackRate(1)
            viewmodel:SendViewModelMatchingSequence(seqID)

            self:StartLoopingSound("npc/vort/attack_charge.wav")

            local tr = owner:GetEyeTrace()

            --local fixedLClawAttachPos, irrelevantAng = LocalToWorld(lClawAttach.Pos, Angle(0, 0, 0), owner:GetPos(), Angle(0, 0, 0))

            owner:StopParticles()

            ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("leftclaw"))
            ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("rightclaw"))
            

            local lClawAttach = owner:GetAttachment(owner:LookupAttachment("leftclaw"))
        local rClawAttach = owner:GetAttachment(owner:LookupAttachment("rightclaw"))

        local tr = owner:GetEyeTrace()
            
            local sequenceID, length = owner:LookupSequence("zapattack1")

            self:SetVar("handParticleTimer", CurTime() + length)
            
            if SERVER then
                owner:ForceSequence("zapattack1", nil, nil, true)
                self:StartChargebeams()
                
            end
        
            self:SetVar("AnimTime", CurTime() + length*0.55)
        end

    elseif self:GetVar("WeaponMode", "Ranged") == "Melee" then
        if owner:KeyDown(IN_WALK) then
            
        else
            --self:SetVar("IsAttacking", true)
            --self:SetVar("Attack", "Claw")

            local lClawAttach = owner:GetAttachment(owner:LookupAttachment("leftclaw"))
            local rClawAttach = owner:GetAttachment(owner:LookupAttachment("rightclaw"))

            -- meleehigh1 = right claw
            -- meleehigh2 = left claw
            -- meleehigh3 = right  claw

            local meleeAttackIndex = math.Round(util.SharedRandom("meleeAttackIndex", 1, 3))

            self:SetVar("IsAttacking", true)
            self:SetVar("Attack", "Swing")

            owner:StopParticles()
            
            if meleeAttackIndex == 1 or meleeAttackIndex == 3 then
                ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("rightclaw"))
            else
                ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("leftclaw"))
            end

            local sequenceID, length = owner:LookupSequence("MeleeHigh"..tostring(meleeAttackIndex))
            self:EmitSound("npc/vort/claw_swing"..tostring(math.random(1,2))..".wav")

            timer.Simple(length, function()
                self:SetVar("IsAttacking", false)
                self:SetVar("Attack", nil)
            end)
            
            if meleeAttackIndex == 1 then
                self:SetVar("AnimTime", CurTime() + length*0.6)
                self:SetVar("handParticleTimer", CurTime() + length*0.6)
            elseif meleeAttackIndex == 2 then
                self:SetVar("AnimTime", CurTime() + length*0.57)
                self:SetVar("handParticleTimer", CurTime() + length*0.57)
                self:SetVar("Attack", "SwingOffset")
            else
                self:SetVar("AnimTime", CurTime() + length*0.28)
                self:SetVar("handParticleTimer", CurTime() + length*0.28)
            end
            
            if SERVER then
                owner:ForceSequence("MeleeHigh"..tostring(meleeAttackIndex), nil, nil, true)
            end      
        end
    elseif self:GetVar("WeaponMode", "Ranged") == "Support" then
        if owner:KeyDown(IN_WALK) then    
            if owner:GetNetVar("EnhanceFormTarget", nil) == nil then
                local tr = owner:GetEyeTrace()
                
                if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
                    tr.Entity:EnhanceForm(owner)

                    if SERVER then
                        owner:ForceSequence("todefend", nil, nil, true)
                    end
                    
                    self:SetVar("handParticleTimer", CurTime() + 0.5)
                    self:SetVar("AnimTime", CurTime() + 0.5)

                    owner:EmitSound("weapons/physgun_off.wav", 75, 115)
                    owner:ForceSequence("todefend", nil, nil, true)

                    timer.Simple(0.8, function()
                        local vortGlowEnt = ents.Create("ix_vortglowent")
                        vortGlowEnt:SetPos(trace.Entity:GetPos() + Vector(0, 0, 90))
                        vortGlowEnt:SetCustomParent(trace.Entity)
                        vortGlowEnt:Spawn()
                        trace.Entity:SetNetVar("vortGlowEnt", vortGlowEnt:EntIndex())
                        trace.Entity:CallOnRemove("removeVortGlow", function(parentEntity)
                            if IsValid(parentEntity) then
                                local childVortGlowEnt = Entity(parentEntity:GetNetVar("vortGlowEnt", -1))

                                if IsValid(childVortGlowEnt) then
                                    Entity(parentEntity:GetNetVar("vortGlowEnt")):Remove()
                                end
                            end
                        end)

                        timer.Simple(0.85, function()
                            if IsValid(vortGlowEnt) then
                                vortGlowEnt:Remove()
                                trace.Entity:SetNetVar("vortGlowEnt", nil)
                            end
                        end)
                    end)

                    ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("leftclaw"))
                    ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("rightclaw"))
                end 
            else
                local tr = owner:GetEyeTrace()
                    
                if IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity:EntIndex() != owner:GetNetVar("EnhanceFormTarget", nil) and tr.Start:Distance(tr.endpos) <= 450 then
                    local oldTarget = Entity(owner:GetNetVar("EnhanceFormTarget"))
                    oldTarget:UnenhanceForm()
                    tr.Entity:EnhanceForm(owner)

                    if SERVER then
                        owner:ForceSequence("todefend", nil, nil, true)
                        owner:EmitSound("weapons/physgun_off.wav", 75, 115)
                        owner:ForceSequence("todefend", nil, nil, true)

                        timer.Simple(0.8, function()
                            local vortGlowEnt = ents.Create("ix_vortglowent")
                            vortGlowEnt:SetPos(trace.Entity:GetPos() + Vector(0, 0, 90))
                            vortGlowEnt:SetCustomParent(trace.Entity)
                            vortGlowEnt:Spawn()
                            trace.Entity:SetNetVar("vortGlowEnt", vortGlowEnt:EntIndex())
                            trace.Entity:CallOnRemove("removeVortGlow", function(parentEntity)
                                if IsValid(parentEntity) then
                                    local childVortGlowEnt = Entity(parentEntity:GetNetVar("vortGlowEnt", -1))

                                    if IsValid(childVortGlowEnt) then
                                        Entity(parentEntity:GetNetVar("vortGlowEnt")):Remove()
                                    end
                                end
                            end)

                            timer.Simple(0.85, function()
                                if IsValid(vortGlowEnt) then
                                    vortGlowEnt:Remove()
                                    trace.Entity:SetNetVar("vortGlowEnt", nil)
                                end
                            end)
                        end)
                    end

                    self:SetVar("handParticleTimer", CurTime() + 0.5)
                    self:SetVar("AnimTime", CurTime() + 0.5)

                    ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("leftclaw"))
                    ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("rightclaw"))
                elseif (!IsValid(tr.Entity) or !tr.Entity:IsPlayer()) or tr.Entity:EntIndex() == owner:GetNetVar("EnhanceFormTarget", nil) and owner:GetPos():Distance(tr.HitPos) <= 450 then
                    local target = Entity(owner:GetNetVar("EnhanceFormTarget"))
                    target:UnenhanceForm()
                end
            end  
        else
            local traceTarget = owner:GetEyeTrace().Entity
            if IsValid(traceTarget) and (traceTarget:IsNPC() or traceTarget:IsPlayer()) and traceTarget:Health() < traceTarget:GetMaxHealth() and owner:IsOnGround() then
                self:SetVar("IsAttacking", true)
                self:SetVar("Attack", "HealthCharge")
                ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("leftclaw"))
                ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("rightclaw"))

                if SERVER then
                    owner:SetNetVar("HealTarget", traceTarget:EntIndex())
                    
                    local sequenceID, length = owner:LookupSequence("vort_defensive_anim")
                    self:SetVar("AnimTime", CurTime() + length)

                    owner:ForceSequence("vort_defensive_anim", nil, 31536000, false, true) -- This is a straight year. This is to make sure they don't move until the healing is done or until they cancel it
                end
            end
        end
    elseif self:GetVar("WeaponMode", "Ranged") == "OtherAbilities" then
        if owner:KeyDown(IN_WALK) then
            
        else
            self:SetVar("IsAttacking", true)
            self:SetVar("Attack", "VortiLamp")
            self:SetVar("handParticleTimer", CurTime() + 0.5)
            self:SetVar("AnimTime", CurTime() + 0.5)

            self:EmitSound("ambient/energy/weld"..tostring(math.random(1,2))..".wav")

            ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("leftclaw"))
            ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("rightclaw"))

            if SERVER then
                owner:ForceSequence("todefend", nil, nil, true)
            end
        end
    end

end

function SWEP:CanPrimaryAttack()
    local owner = self:GetOwner()
    local char = owner:GetCharacter()
    local vortessence = char:GetVortessence()
    local altDown = owner:KeyDown(IN_WALK)
    if self:GetVar("IsAttacking", false) then
        return false
    elseif self:GetVar("WeaponMode", "Ranged") == "Ranged" then
        if altDown and vortessence >= self.STOMPCONSUMP then 
            return true
        elseif !altDown and vortessence >= self.ZAPCONSUMP then
            return true
        end
    elseif self:GetVar("WeaponMode", "Ranged") == "Melee" then
        if !altDown and vortessence >= self.SWINGCONSUMP then 
            return true
        end
    elseif self:GetVar("WeaponMode", "Ranged") == "OtherAbilities" then
        return true
    else
        return true
    end

    --return false
    
end

function SWEP:SecondaryAttack()
    if !IsFirstTimePredicted() then return end
    if !self:CanSecondaryAttack() then return end

    local owner = self:GetOwner()
    local char = owner:GetCharacter()

    if (self:GetVar("Attack", nil) == "HealthCharge") then
        self:EndHealing()
        return
    end

    if self:GetVar("WeaponMode", "Ranged") == "Ranged" then
        if !owner:KeyDown(IN_WALK) then
            self:StartLoopingSound("npc/vort/attack_charge.wav")

            self:SetVar("IsAttacking", true)
            self:SetVar("Attack", "QuickZap")

            owner:StopParticles()

            ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("rightclaw"))
            ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("leftclaw"))
            
            self:SetVar("handParticleTimer", CurTime() + 2)

            local sequenceID, length = owner:LookupSequence("meleehigh3")

            self:SetVar("AnimTime", CurTime() + length*0.3)

            if SERVER then
                owner:ForceSequence("meleehigh3", nil, nil, true)
            end
        else
            self:StartLoopingSound("npc/vort/attack_charge.wav")

            self:SetVar("IsAttacking", true)
            self:SetVar("Attack", "Stun")

            if SERVER then
                owner:ForceSequence("meleehigh3", nil, nil, true)
            end

            self:SetVar("handParticleTimer", CurTime() + 2)
        
            owner:StopParticles()

            ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("rightclaw"))
            ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("leftclaw"))
            
            local sequenceID, length = owner:LookupSequence("meleehigh3")

            self:SetVar("AnimTime", CurTime() + length*0.3)

            if SERVER then
                owner:ForceSequence("meleehigh3", nil, nil, true)
            end
        end
    elseif self:GetVar("WeaponMode", "Ranged") == "ChargedPunch" then

    elseif self:GetVar("WeaponMode", "Ranged") == "Support" then
        /*

        if owner:KeyDown(IN_WALK) then
            local traceTarget = owner:GetEyeTrace().Entity
            if IsValid(traceTarget) and traceTarget:IsPlayer() and (traceTarget:GetCharacter():IsFreeVortigaunt()) then
                self:SetVar("IsAttacking", false)
                self:SetVar("handParticleTimer", CurTime() + 1.25)
                ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("leftclaw"))
                ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("rightclaw"))

                if SERVER then
                    local target = traceTarget
                    owner:SetNetVar("vortShareRecipient", traceTarget:EntIndex())
                    target:SetNetVar("vortShareInflictor", owner:EntIndex())

                    owner:GetCharacter():SetMaxVortessence(400)
                    target:GetCharacter():SetMaxVortessence(400)

                    local ownerVortessence = owner:GetCharacter():GetVortessence()
                    local targetVortessence = target:GetCharacter():GetVortessence()

                    owner:GetCharacter():SetVortessence(ownerVortessence + targetVortessence)
                    target:GetCharacter():SetVortessence(ownerVortessence + targetVortessence)
                    owner:SetNetVar("originalVortessence", ownerVortessence)
                    target:SetNetVar("originalVortessence", targetVortessence)

                    print(ownerVortessence + targetVortessence)

                    local sequenceID, length = owner:LookupSequence("todefend")
                    self:SetVar("AnimTime", CurTime() + length)

                    owner:ForceSequence("todefend", nil, length, true)
                    
                    owner:EmitSound("vo/npc/vortigaunt/weshare.wav", 75, math.random(90, 105), 1, CHAN_AUTO)
                    ix.chat.Send(owner, "ic", "We shall share the vortessence!", false, nil, nil)
                end

                debugoverlay.ScreenText( 0.01, 0.2, "Max Vortessence "..tostring(owner:GetCharacter():GetMaxVortessence()), 5)
                debugoverlay.ScreenText( 0.01, 0.215, "Vortessence "..tostring(owner:GetCharacter():GetVortessence()), 5)
                
            end
        else
            local traceTarget = owner:GetEyeTrace().Entity
            if IsValid(traceTarget) and traceTarget:IsPlayer() and (traceTarget:GetCharacter():IsFreeVortigaunt()) then
                owner:StopVortessenceShare()
            end
        end
        */
    elseif self:GetVar("WeaponMode", "Ranged") == "OtherAbilities" then
        if !owner:KeyDown(IN_WALK) then
            if SERVER then
                owner:SetNetVar("xrayMode", !owner:GetNetVar("xrayMode", false))

                if owner:GetNetVar("xrayMode", false) then
                    owner:EmitSound("vo/npc/vortigaunt/vortigese09.wav", 75, math.random(90, 105), 1, CHAN_AUTO)
                    owner:SetNetVar("xrayShiftTimer", CurTime())
                    owner:SetNetVar("LastVortalEyeConsump", CurTime())
                else
                    owner:SetNetVar("xrayShiftTimer", CurTime())
                end
            end
        end
    end
end

function SWEP:CanSecondaryAttack()
    local owner = self:GetOwner()
    local char = owner:GetCharacter()
    local vortessence = char:GetVortessence()
    local altDown = owner:KeyDown(IN_WALK)
    if self:GetVar("Attack", nil) == "HealthCharge" then
        return true
    elseif self:GetVar("IsAttacking", false) then
        return false
    elseif self:GetVar("WeaponMode", "Ranged") == "Ranged" then
        if altDown and vortessence >= self.QUICKZAPCONSUMP then 
            return true
        elseif !altDown and vortessence >= self.STUNCONSUMP then
            return true
        end
    elseif self:GetVar("WeaponMode", "Ranged") == "OtherAbilities" then
        if altDown then
            return true 
        elseif !altDown then
            if SERVER then 
                return char:CanConsumeVortessence(VORTALEYECONSUMPRATE*FrameTime())
            end
        end
    else
        return true
    end
end

function SWEP:Think()
    local owner = self:GetOwner()
    local char = owner:GetCharacter()
    local animTime = self:GetVar("AnimTime", -1)
    local isAttacking = self:GetVar("IsAttacking", false)
    local attack = self:GetVar("Attack", nil)
    local weaponMode = self:GetVar("WeaponMode", "Ranged")
    local handParticleTimer = self:GetVar("handParticleTimer", -1)
    local curTime = CurTime()
    local healTargetIndex = owner:GetNetVar("HealTarget", -1)
    local healTarget = Entity(healTargetIndex)
    local viewmodel = owner:GetViewModel()

    if !isAttacking and viewmodel:GetSequenceName(viewmodel:GetSequence()) != "ActionIdle" then
        viewmodel:SendViewModelMatchingSequence(viewmodel:LookupSequence("actionidle"))
    end

    if (isAttacking) and (animTime != -1 and curTime >= animTime) then
        if weaponMode == "Ranged" then
            if attack == "Stomp" then
                self:SetVar("IsAttacking", false)
                self:SetVar("AnimTime", -1)
                self:SetVar("Attack", nil)

                local effectData = EffectData()
                self:StopLoopingSound(1)
                
                effectData:SetOrigin(owner:GetPos() + Vector(0, 0, 0))
                util.Effect("VortDispel", effectData)
                util.ScreenShake(owner:GetPos(), 2, 1, 0.5, 450)
                
                for k, v in pairs(ents.GetAll()) do
                    if IsValid(v) and (v:IsPlayer() or v:IsNPC()) and v.TakeDamageInfo != nil then
                        if v == owner or v:IsVortigaunt() then continue end
                        local distance = owner:GetPos():Distance(v:GetPos())
                        if distance <= 180 then
                            local dmgInfo = DamageInfo()
                            dmgInfo:SetDamage(self:ScaleValueToVortLevel(self.STOMPDAMAGE))

                            dmgInfo:SetDamageType(DMG_SHOCK)
                            dmgInfo:SetAttacker(owner)
                            dmgInfo:SetInflictor(self)
                            dmgInfo:SetDamageForce((v:GetPos()-owner:GetPos()):GetNormalized()*self.STOMPFORCE)
                            v:TakeDamageInfo(dmgInfo)
                        end
                    end
                end

                if SERVER then
                    self:TryAttackSound()
                    char:ConsumeVortessence(self.STOMPCONSUMP) -- we handle vortessence consumption here because
                    -- if the player switches weapons mid attack they'll still lose the vortessence
                    -- but not attack
                end

            elseif attack == "Zap" then
                self:SetVar("IsAttacking", false)
                self:SetVar("AnimTime", -1)
                self:SetVar("Attack", nil)

                self:StopLoopingSound(1)
                self:EmitSound("npc/vort/attack_shoot.wav", 75, 100, 1, CHAN_WEAPON)

                local tr = owner:GetEyeTrace()

                if SERVER then
                    util.Decal( "FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, ply )
                end

                local lClawAttach = owner:GetAttachment(owner:LookupAttachment("leftclaw"))
                local rClawAttach = owner:GetAttachment(owner:LookupAttachment("rightclaw"))

                util.ParticleTracerEx("vortigaunt_beam", lClawAttach.Pos, tr.HitPos, false, owner:EntIndex(), owner:LookupAttachment("leftclaw"))
                util.ParticleTracerEx("vortigaunt_beam", rClawAttach.Pos, tr.HitPos, false, owner:EntIndex(), owner:LookupAttachment("rightclaw"))  

                if SERVER then
                    self:StartDamageBeams(CLAWS_BOTH)
                    if tr.Entity:GetClass() == "npc_antlion" or tr.Entity:GetClass() =="npc_antlion_worker" then
                        tr.Entity:SetActivity(ACT_RESET)
                        tr.Entity:SetActivity(ACT_ANTLION_FLIP)
                    end

                    tr.Entity:Fire("BecomeRagdolly")
                end

                if IsValid(tr.Entity) and IsEntity(tr.Entity) and tr.Entity.TakeDamageInfo != nil and tr.Entity:GetClass() != "prop_ragdoll" then 
                    local dmgInfo = DamageInfo()
                    dmgInfo:SetDamage(9999999)
                    dmgInfo:SetDamageType(DMG_DISSOLVE)
                    dmgInfo:SetAttacker(owner)
                    dmgInfo:SetInflictor(self)
                    if tr.Entity:GetClass() != "prop_ragdoll" then
                        dmgInfo:SetDamageForce(owner:GetAimVector():GetNormalized()*self.ZAPFORCE)
                    end

                    if tr.Entity:IsPlayer() or tr.Entity:IsNPC() then
                        self:TryAttackSound()
                    end

                    tr.Entity:TakeDamageInfo(dmgInfo)

                    if tr.Entity:GetClass() == "npc_antlion" or tr.Entity:GetClass() =="npc_antlion_worker" then
                        tr.Entity:ClearCondition()
                        tr.Entity:SetCondition(COND_ANTLION_FLIP)
                    end

                elseif IsValid(tr.Entity) and IsEntity(tr.Entity) and tr.Entity:GetClass() == "prop_ragdoll" and tr.Entity:GetModel() == "models/antlion_guard.mdl" and !tr.Entity:GetNetVar("bugbaitHarvested", false) then
                    local effectData = EffectData()
                    effectData:SetOrigin(tr.HitPos)
                    util.Effect("AntlionGib", effectData)

                    if SERVER then
                        ix.item.Spawn("bugbait", tr.HitPos)
                        tr.Entity:SetNetVar("bugbaitHarvested", true)
                    end

                    
                end

                if SERVER then
                    char:ConsumeVortessence(self.ZAPCONSUMP)
                end
            elseif attack == "Stun" then
                self:StopLoopingSound(1)
                self:SetVar("IsAttacking", false)
                self:SetVar("AnimTime", -1)
                self:SetVar("Attack", nil)

                local tr = owner:GetEyeTrace()

                if SERVER then
                    util.Decal( "FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, ply )
                end

                self:EmitSound("npc/vort/vort_attack_shoot"..tostring(math.random(3,4))..".wav", 75, 100, 1, CHAN_WEAPON)
                
                local rClawAttach = owner:GetAttachment(owner:LookupAttachment("rightclaw"))
                util.ParticleTracerEx("vortigaunt_beam", rClawAttach.Pos, tr.HitPos, false, owner:EntIndex(), owner:LookupAttachment("rightclaw"))

                if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
                    tr.Entity:ScreenFade(SCREENFADE.IN, Color(36, 255, 93), math.floor(self.STUNTIME*2/5), math.floor(self.STUNTIME*3/5))
                elseif IsValid(tr.Entity) and tr.Entity:IsNPC() then 
                    tr.Entity:SetVar("IsStunned", true)
                    tr.Entity:SetVar("StunTime", CurTime() + self:ScaleValueToVortLevel(self.STUNTIME))
                    local stunnedNPCs = self:GetVar("stunnedNPCs", {})
                    stunnedNPCs[#stunnedNPCs + 1] = {tr.Entity, CurTime() + self:ScaleValueToVortLevel(3)}
                    
                    local class = tr.Entity:GetClass()

                    if SERVER then
                        local canStun = true
                        if class == "npc_combine_camera" or class == "npc_manhack" or class == "npc_cscanner" or class == "npc_rollermine" or class == "npc_turret_floor" or class == "npc_turret_ceiling" then
                            canStun = false
                        end

                        char:ConsumeVortessence(self.STUNCONSUMP)

                        if canStun and class != "npc_barnacle" then 
                            delay = self.STUNTIME
                        elseif canStun and class == "npc_barnacle" then
                            tr.Entity:SetNPCState(COND_SCHEDULE_DONE)
                        end

                    end
                end
            elseif attack == "QuickZap" then
                self:SetVar("IsAttacking", false)
                self:SetVar("AnimTime", -1)
                self:SetVar("Attack", nil) 

                self:StopLoopingSound(1)
                self:EmitSound("npc/vort/vort_explode"..tostring(math.random(1, 2))..".wav", 75, 100, 1, CHAN_WEAPON)

                local tr = owner:GetEyeTrace()

                if SERVER then
                    util.Decal( "FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, ply )
                end

                local rClawAttach = owner:GetAttachment(owner:LookupAttachment("rightclaw"))
                util.ParticleTracerEx("vortigaunt_beam", rClawAttach.Pos, tr.HitPos, false, owner:EntIndex(), owner:LookupAttachment("rightclaw"))  

                if SERVER then
                    self:StartDamageBeams(CLAWS_RIGHT)
                end

                if IsValid(tr.Entity) and IsEntity(tr.Entity) and tr.Entity.TakeDamageInfo != nil then 
                    local dmgInfo = DamageInfo()
                    dmgInfo:SetDamage(self:ScaleValueToVortLevel(self.QUICKZAPDAMAGE))
                    dmgInfo:SetDamageType(DMG_SHOCK)
                    dmgInfo:SetAttacker(owner)
                    dmgInfo:SetInflictor(self)
                    if tr.Entity:IsNPC() or tr.Entity:IsPlayer() then
                        dmgInfo:SetDamageForce(owner:GetAimVector():GetNormalized()*self.QUICKZAPFORCE * 40)
                    else
                        dmgInfo:SetDamageForce(owner:GetAimVector():GetNormalized()*self.QUICKZAPFORCE * 10)
                    end
                    dmgInfo:SetDamagePosition(tr.HitPos)
                    tr.Entity:TakeDamageInfo(dmgInfo)
                else
                    --util.Decal("FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
                end

                if SERVER then
                    self:TryAttackSound()
                    char:ConsumeVortessence(self.QUICKZAPCONSUMP)
                end
            end
        elseif weaponMode == "Melee" then
            if attack == "Swing" then
                --self:SetVar("IsAttacking", false)
                self:SetVar("AnimTime", -1)
                --self:SetVar("Attack", nil)

                local tr = owner:GetEyeTrace()

                if IsValid(tr.Entity) and tr.Entity:GetPos():Distance(owner:GetPos()) <= 72 then
                    self:EmitSound("npc/vort/vort_explode"..tostring(math.random(1,2))..".wav")
                    if SERVER then
                        
                        ParticleEffect("vortigaunt_glow_beam_cp1b", tr.HitPos, Angle(0, 0, 0), tr.Entity)
                        ParticleEffect("vortigaunt_glow_beam_cp1", tr.HitPos, Angle(0, 0, 0), tr.Entity)

                        local dmgInfoClub = DamageInfo()
                        dmgInfoClub:SetDamage(self:ScaleValueToVortLevel(self.MELEEDAMAGECLUB))
                        dmgInfoClub:SetDamageType(DMG_CLUB)
                        dmgInfoClub:SetAttacker(owner)
                        dmgInfoClub:SetInflictor(self)

                        local dmgInfoVortal = DamageInfo()
                        dmgInfoVortal:SetDamage(self:ScaleValueToVortLevel(self.MELEEDAMAGESHOCK))
                        dmgInfoVortal:SetDamageType(DMG_SHOCK)
                        dmgInfoVortal:SetAttacker(owner)
                        dmgInfoVortal:SetInflictor(self)
                        if tr.Entity:IsNPC() or tr.Entity:IsPlayer() then
                            dmgInfo:SetDamageForce(owner:GetAimVector():GetNormalized()*self.QUICKZAPFORCE * 1000)
                        else
                            dmgInfo:SetDamageForce(owner:GetAimVector():GetNormalized()*self.QUICKZAPFORCE * 10)
                        end

                        self:TryAttackSound()
                        char:ConsumeVortessence(self.SWINGCONSUMP)

                        tr.Entity:TakeDamageInfo(dmgInfoClub)
                        tr.Entity:TakeDamageInfo(dmgInfoVortal)
                    end
                end
            elseif attack == "SwingOffset" then 
                --self:SetVar("IsAttacking", false)
                self:SetVar("AnimTime", -1)
                --self:SetVar("Attack", nil)

                local tr = owner:GetEyeTrace()

                if IsValid(tr.Entity) and tr.Entity:GetPos():Distance(owner:GetPos()) <= 72 then
                    self:EmitSound("npc/vort/vort_explode"..tostring(math.random(1,2))..".wav")
                    if SERVER then
                        
                        ParticleEffect("vortigaunt_glow_beam_cp1b", tr.HitPos, Angle(0, 0, 0), tr.Entity)
                        ParticleEffect("vortigaunt_glow_beam_cp1", tr.HitPos, Angle(0, 0, 0), tr.Entity)

                        local dmgInfoClub = DamageInfo()
                        dmgInfoClub:SetDamage(self:ScaleValueToVortLevel(self.MELEEDAMAGECLUB))
                        dmgInfoClub:SetDamageType(DMG_CLUB)
                        dmgInfoClub:SetAttacker(owner)
                        dmgInfoClub:SetInflictor(self)

                        local dmgInfoVortal = DamageInfo()
                        dmgInfoVortal:SetDamage(self:ScaleValueToVortLevel(self.MELEEDAMAGESHOCK))
                        dmgInfoVortal:SetDamageType(DMG_SHOCK)
                        dmgInfoVortal:SetAttacker(owner)
                        dmgInfoVortal:SetInflictor(self)
                        if tr.Entity:GetClass() != "prop_ragdoll" then
                            dmgInfoClub:SetDamageForce(owner:GetAimVector():GetNormalized()*self.MELEEDAMAGESHOCK * 1000 + owner:GetRight()*5000)
                        end

                        self:TryAttackSound()
                        char:ConsumeVortessence(self.SWINGCONSUMP)

                        

                        tr.Entity:TakeDamageInfo(dmgInfoClub)
                        tr.Entity:TakeDamageInfo(dmgInfoVortal)
                    end
                end
            end
        elseif weaponMode == "Support" then
            if attack == "HealthCharge" then
                if SERVER then
                    self:SetNetVar("DrawHealBeams", true)
                    self:SetNetVar("StartDrawHealBeamTime", curTime)
                    owner:SetNetVar("LastVortHeal", curTime)
                    self:SetVar("AnimTime", -1)
                end
            elseif attack == "FormEnhancement" then
                
            end
        elseif weaponMode == "OtherAbilities" then
            if attack == "VortiLamp" then
                self:SetVar("IsAttacking", false)
                self:SetVar("AnimTime", -1)
                self:SetVar("Attack", nil)

                self:StopSound("npc/vort/health_charge.wav")

                if owner:GetNetVar("vortlight", nil) == nil then
                    if SERVER then
                        char:ConsumeVortessence(self.VORTILAMPSTARTCONSUMP)
                        owner:SetNetVar("LastVortilampConsump", CurTime()) -- Doing this makes it so there's not an immediate vortessence point taken on vortilamp starting.
                        local vortlight = ents.Create("ix_vortlight")
                        vortlight:SetPos(owner:GetPos())
                        vortlight:SetAngles(Angle(0, 0, 0))

                        vortlight:Spawn() 

                        vortlight:SetCustomParent(owner:EntIndex())

                        --ParticleEffectAttach("vortigaunt_hand_glow", PATTACH_POINT_FOLLOW, vortlight, vortlight:LookupAttachment("static_prop"))
                        owner:SetNetVar("vortlight", vortlight:EntIndex())
                    end
                else
                    local vortlight = Entity(owner:GetNetVar("vortlight"))
                    
                    if SERVER then
                        owner:SetNetVar("vortlight", nil)
                        vortlight:Remove()
                    end
                end
            end
        end
    end

    if (handParticleTimer <= curTime and handParticleTimer != -1) then
        owner:StopParticles()
        self:SetVar("handParticleTimer", -1)
        local trace = owner:GetEyeTrace()
    end

    if IsValid(healTarget) and attack == "HealthCharge" then    
        local nextHealTime = self:GetNetVar("NextHealTime", -1)
        if owner:GetPos():Distance(healTarget:GetPos()) > 256 or healTarget:Health() <= 0 then
            self:EndHealing()
        end

        if healTarget:Health() >= healTarget:GetMaxHealth() then
            self:EndHealing()
        end
    end
end

function SWEP:Reload()
    if !IsFirstTimePredicted() then return end

    if SERVER then
        self:GetOwner():GetCharacter():SetVortessence(self:GetOwner():GetCharacter():GetMaxVortessence())
    end
end

function SWEP:OnRemove()
    if self.vortlight then self.vortlight:Remove() end

    for k, v in ipairs(ents.FindByClass("ix_vortlight")) do
        v:Remove()
    end
end

function SWEP:ScaleValueToVortLevel(num)
    return num
end

function SWEP:DrawWorldModel(flags)
    return
end

local spriteTexture = Material("sprites/glow04_noz")
local maxHealthColor = Color(0, 255, 0)
local vortModelOffset = Vector(0, 0, 0)

if CLIENT then
    local render_SetMaterial = render.SetMaterial
    local render_DrawSprite = render.DrawSprite

    oldVortessencePixels = -1
    newVortessencePixels = -1

    oldMaxVortessence = -1
    newMaxVortessence = -1

    start = 0

    function SWEP:DrawHUD()
        local owner = self:GetOwner()
        local drawHealBeams = self:GetNetVar("DrawHealBeams", false)
        local healTarget = Entity(owner:GetNetVar("HealTarget", -1))
        local curTime = CurTime()

        local vortessence = owner:GetCharacter():GetVortessence()
        local dispVort = Lerp( ( curTime - start ) / 0.05, oldVortessencePixels, newVortessencePixels )

        if ( oldVortessencePixels == -1 and newVortessencePixels == -1 ) then
            oldVortessencePixels = vortessence
            newVortessencePixels = vortessence
        end
        
        if newVortessencePixels != vortessence then
            if dispVort != vortessence then
                newVortessencePixels = dispVort
            end

            oldVortessencePixels = newVortessencePixels
            newVortessencePixels = vortessence
            start = curTime
        end


        draw.RoundedBox(4, ScrW() - 50 - VORTHUD.BARWIDTH, ScrH() - 25 - VORTHUD.MAXBARHEIGHT, VORTHUD.BARWIDTH, VORTHUD.MAXBARHEIGHT, drainedBarColor)
        draw.SimpleText("Vortessence", "DermaDefault", ScrW() - 50 - VORTHUD.BARWIDTH/2, ScrH() - 25 - VORTHUD.MAXBARHEIGHT - 12, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.RoundedBox(4, ScrW() - 50 - VORTHUD.BARWIDTH, ScrH() - 25 - VORTHUD.MAXBARHEIGHT + 200 - dispVort, VORTHUD.BARWIDTH, dispVort, vortessenceBarColor)

        if drawHealBeams and healTarget != NULL and !owner:GetNetVar("xrayMode", false) then
            local basePos, hc1pos, hc2pos, hc3pos, hc4pos, hc5pos = healTarget:GetHealthPosVectors()

            local renderTransparency = math.Clamp(255*math.Clamp(curTime - self:GetNetVar("StartDrawHealBeamTime"), 0, 1)*7, 0, 255)

            local H, S, V = ColorToHSV(maxHealthColor)
            local health = healTarget:Health()
            local maxHealth = healTarget:GetMaxHealth()

            spriteColor = HSVToColor((H - 115 + math.floor(115*(health/maxHealth))), S, V)

            spriteColor.a = renderTransparency

            if LocalPlayer():EntIndex() == GetViewEntity():EntIndex() and !owner:GetNetVar("xrayMode", false) then
                cam.Start3D()
                    render_SetMaterial(spriteTexture)
                    render_DrawSprite(basePos, 8, 8, spriteColor)
                cam.End3D()
            end
        end

        if !self.doingAnim then
            local act, sequence = hook.Run("CalcMainActivity", owner, owner:GetVelocity())
            if sequence != -1 then
                self.doingAnim = true
            end
        end
    end




end

function SWEP:Holster(weapon)
    if not IsFirstTimePredicted() then return end

    local owner = self:GetOwner()

    self:SetVar("IsAttacking", false)
    self:SetVar("Attack", nil)
    self:SetVar("AnimTime", -1)

    owner:StopParticles()
    self:SetVar("handParticleTimer", -1)

    self:EndHealing() -- A lot of code in here is redundant, but it's fine.

    if SERVER then
        owner:LeaveSequence()  
    end

    self:StopLoopingSound(1)
    return true
end

function SWEP:EndHealing()
    local owner = self:GetOwner()

    self:SetVar("AnimTime", -1)
    self:SetVar("IsAttacking", false)
    self:SetVar("Attack", nil)

    self:SetVar("handParticleTimer", -1)

    if SERVER then
        if owner:GetNetVar("HealTarget", -1) != -1 then
            local healTarget = Entity(owner:GetNetVar("HealTarget"))
            healTarget:SetNetVar("healthBuildup", nil)
        end
        owner:SetNetVar("HealTarget", -1)
        owner:SetNetVar("LastVortHeal", nil)
        self:SetNetVar("DrawHealBeams", false)

        owner:LeaveSequence()
    end

    owner:StopParticles()
    
    self:StopSound("npc/vort/health_charge.wav")
end

-- Radial Menu
if CLIENT then
    -- enums
    local WIDE = 1
    local TALL = 2

    local RANGED = 1
    local MELEE = 2
    local OTHERABILITIES = 3
    local SUPPORT = 4

    -- tile structs
    local tilesStruct = {
        ["ranged"] = {
            ["width"] = 487,
            ["height"] = 345,
            ["x"] = ScrW()/2 - 487/2,
            ["y"] = ScrH()/2 - 345 - 25,
            ["widthSelected"] = 578,
            ["heightSelected"] = 409,
            ["xSelected"] = ScrW()/2 - 578/2 - 1,
            ["ySelected"] = ScrH()/2 - 409 - 25,
            ["startX"] = ScrW()/2,
            ["startY"] = ScrH()/2 - 250,
            ["pathNormal"] = "vgui/ranged.png",
            ["pathSelected"] = "vgui/rangedselected.png",
            ["orientation"] = WIDE,
            ["enum"] = RANGED
        },
        ["support"] = {
            ["width"] = 345,
            ["height"] = 487,
            ["x"] = ScrW()/2 - 345 - 25,
            ["y"] = ScrH()/2 - 487/2,
            ["widthSelected"] = 409,
            ["heightSelected"] = 578,
            ["xSelected"] = ScrW()/2 - 409 - 25,
            ["ySelected"] = ScrH()/2 - 578/2 - 1,
            ["startX"] = ScrW()/2 - 250,
            ["startY"] = ScrH()/2,
            ["pathNormal"] = "vgui/support.png",
            ["pathSelected"] = "vgui/supportselected.png",
            ["orientation"] = TALL,
            ["enum"] = MELEE
        },
        ["otherAbilities"] = {
            ["width"] = 487,
            ["height"] = 345,
            ["x"] = ScrW()/2 - 487/2,
            ["y"] = ScrH()/2 + 25,
            ["widthSelected"] = 578,
            ["heightSelected"] = 409,
            ["xSelected"] = ScrW()/2 - 578/2 - 1,
            ["ySelected"] = ScrH()/2 + 25,
            ["startX"] = ScrW()/2,
            ["startY"] = ScrH()/2 + 250,
            ["pathNormal"] = "vgui/otherabilities.png",
            ["pathSelected"] = "vgui/otherabilitiesselected.png",
            ["orientation"] = WIDE,
            ["enum"] = OTHERABILITIES
        },
        ["melee"] = {
            ["width"] = 345,
            ["height"] = 487,
            ["x"] = ScrW()/2 + 25,
            ["y"] = ScrH()/2 - 487/2,
            ["widthSelected"] = 409,
            ["heightSelected"] = 578,
            ["xSelected"] = ScrW()/2 + 25,
            ["ySelected"] = ScrH()/2 - 578/2 - 1,
            ["startX"] = ScrW()/2 + 250,
            ["startY"] = ScrH()/2,
            ["pathNormal"] = "vgui/melee.png",
            ["pathSelected"] = "vgui/meleeselected.png",
            ["orientation"] = TALL,
            ["enum"] = SUPPORT
        }
    }

    local PANEL = {}

    function PANEL:Init()
        self:SetSize(ScrW(), ScrH())
        self:Center()

        self:MakePopup()
        self:SetKeyboardInputEnabled(false)

        local oldCursorPos = LocalPlayer():GetActiveWeapon():GetVar("lastMousePos", nil)

        if oldCursorPos != nil then
            input.SetCursorPos(oldCursorPos.x, oldCursorPos.y)
        end

        self.rangedTile = vgui.Create("DImage", self)
        self.rangedTile:SetImage("vgui/ranged.png")
        self.rangedTile:SetSize(487, 345)
        self.rangedTile:SetPos(ScrW()/2 - 487/2, ScrH()/2 - 345 - 25)
        self.rangedTile.enum = RANGED
        self.rangedTile.struct = tilesStruct.ranged

        self.supportTile = vgui.Create("DImage", self)
        self.supportTile:SetImage("vgui/support.png")
        self.supportTile:SetSize(345, 487)
        self.supportTile:SetPos(ScrW()/2 - 345 - 25, ScrH()/2 - 487/2)
        self.supportTile.enum = SUPPORT
        self.supportTile.struct = tilesStruct.support

        self.otherAbilitiesTile = vgui.Create("DImage", self)
        self.otherAbilitiesTile:SetImage("vgui/otherabilities.png")
        self.otherAbilitiesTile:SetSize(487, 345)
        self.otherAbilitiesTile:SetPos(ScrW()/2 - 487/2, ScrH()/2 + 25)
        self.otherAbilitiesTile.enum = OTHERABILITIES
        self.otherAbilitiesTile.struct = tilesStruct.otherAbilities

        self.meleeTile = vgui.Create("DImage", self)
        self.meleeTile:SetImage("vgui/melee.png")
        self.meleeTile:SetSize(345, 487)
        self.meleeTile:SetPos(ScrW()/2 + 25, ScrH()/2 - 487/2)
        self.meleeTile.enum = MELEE
        self.meleeTile.struct = tilesStruct.melee
        
        local weaponMode = LocalPlayer():GetActiveWeapon():GetVar("WeaponMode", "Ranged")
        
        if weaponMode == "Ranged" then
            self:SetFirstSelection(self.rangedTile)
        elseif weaponMode == "Melee" then
            self:SetFirstSelection(self.meleeTile)
        elseif weaponMode == "OtherAbilities" then
            self:SetFirstSelection(self.otherAbilitiesTile)
        elseif weaponMode == "Support" then
            self:SetFirstSelection(self.supportTile)
        end
    end

    function PANEL:Think()
        local scrX, scrY = self:CursorPos()
        local x = scrX - ScrW()/2 -- x and y variables are just cursor coordinates but if the center of the screen
        local y = ScrH()/2 - scrY -- was the origin, and not the top left corner.
        local distance = self:CalcDistance(0, 0, x, y) -- mouse's distance from the origin 
        local pi = math.pi

        local angle = math.deg(math.atan2(y, x))

        if distance > 350 then
        /*
            LocalPlayer():Notify("Out of Bounds") 
            x = x - x/distance
            y = y - x/distance

            input.SetCursorPos(x, y)
            */
        end

        if angle < 0 then
            angle = angle + 360
        end

        if angle >= 315 or angle <= 45 then
            self:SetSelection(self.meleeTile)
        elseif angle >= 45 and angle <= 135 then
            self:SetSelection(self.rangedTile)
        elseif angle >= 135 and angle <= 225 then
            self:SetSelection(self.supportTile)
        elseif angle >= 225 and angle <= 315 then
            self:SetSelection(self.otherAbilitiesTile)
        end

        local x, y = self:CursorPos()

        self.oldCursorPos = {
            ["x"] = x,
            ["y"] = y
        }
    end

    function PANEL:CalcDistance(x1, y1, x2, y2)
        return math.sqrt(math.pow(x2-x1, 2) + math.pow(y2-y1, 2))
    end

    function PANEL:SetSelection(tile)
        if self.selectedTile.enum == tile.enum then return end

        surface.PlaySound("ui/buttonrollover.wav")

        local struct = self.selectedTile.struct

        self.selectedTile:SetImage(struct.pathNormal)
        self.selectedTile:SetSize(struct.width, struct.height)
        self.selectedTile:SetPos(struct.x, struct.y)
        
        local newStruct = tile.struct

        self.selectedTile = tile
        self.selectedTile:SetImage(newStruct.pathSelected)
        self.selectedTile:SetSize(newStruct.widthSelected, newStruct.heightSelected)
        self.selectedTile:SetPos(newStruct.xSelected, newStruct.ySelected)

        local weaponMode = nil

        if (self.selectedTile.enum == RANGED) then
            weaponMode = "Ranged"
        elseif (self.selectedTile.enum == MELEE) then
            weaponMode = "Melee"
        elseif (self.selectedTile.enum == OTHERABILITIES) then
            weaponMode = "OtherAbilities"
        elseif (self.selectedTile.enum == SUPPORT) then
            weaponMode = "Support"
        end

        LocalPlayer():GetActiveWeapon():SetVar("WeaponMode", weaponMode)
        netstream.Start("SetVortWeaponMode", weaponMode)
    end 

    function PANEL:SetFirstSelection(tile)
        local newStruct = tile.struct
        self.selectedTile = tile
        self.selectedTile:SetImage(newStruct.pathSelected)
        self.selectedTile:SetSize(newStruct.widthSelected, newStruct.heightSelected)
        self.selectedTile:SetPos(newStruct.xSelected, newStruct.ySelected)
    end 

    function PANEL:OnRemove()
        local scrX, scrY = self:CursorPos()
        LocalPlayer():GetActiveWeapon():SetVar("lastMousePos", {
            ["x"] = scrX,
            ["y"] = scrY
        })
    end

    vgui.Register("VortRadialMenu", PANEL, "Panel")


    hook.Add("KeyPress", "OpenVortRadialMenu", function(client, keycode)
        if !IsFirstTimePredicted() then return end

        local activeWeapon = client:GetActiveWeapon()

        if activeWeapon != NULL and client:GetActiveWeapon():GetClass() == "weapon_vortswep" then
            if keycode == IN_ZOOM then
                if CLIENT then
                    if client:GetActiveWeapon():GetVar("IsAttacking", false) then
                        return 
                    else
                        local radialMenu = vgui.Create("VortRadialMenu")
                        client:SetVar("radialMenu", radialMenu)
                    end
                end
            end
        end
    end)

    hook.Add("KeyRelease", "CloseVortRadialMenu", function(client, keycode)
        if !IsFirstTimePredicted() then return end

        local activeWeapon = client:GetActiveWeapon()

        if activeWeapon != NULL and activeWeapon:GetClass() == "weapon_vortswep" then
            if keycode == IN_ZOOM then
                if CLIENT then
                    client:GetVar("radialMenu"):Remove()
                end
            end
        end
    end)

end

if SERVER then

    function SWEP:TryAttackSound()
        local owner = self:GetOwner()
        if math.random(1, 10) == 5 and ix.option.Get(owner, "autoVortMessages", false) then
            local attacksound = self.ATTACKSOUNDS[math.random(1, #self.ATTACKSOUNDS)]
            owner:EmitSound(attacksound[1], 75, math.random(90, 105), 1, CHAN_AUTO)
            ix.chat.Send(owner, "ic", attacksound[2], false, nil, nil)
        end
    end

    function SWEP:StartChargebeams()
        local owner = self:GetOwner()
        local lClawAttach = owner:GetAttachment(owner:LookupAttachment("leftclaw"))
        local rClawAttach = owner:GetAttachment(owner:LookupAttachment("rightclaw"))

        local right = owner:GetRight() 

        local lDist = math.random(-25, -100)
        local rDist = math.random(25, 100)

        local lEndPos = owner:GetPos() + right * lDist
        local rEndPos = owner:GetPos() + right * rDist

        lEndPos.z = owner:GetPos().z
        rEndPos.z = owner:GetPos().z
        
        local lTraceData = {
            ["start"] = lClawAttach.Pos,
            ["endpos"] = lEndPos,
            ["filter"] = owner,
        }

        local rTraceData = {
            ["start"] = rClawAttach.Pos,
            ["endpos"] = rEndPos,
            ["filter"] = owner,
        }

        local lTraceResult = util.TraceLine(lTraceData)
        local rTraceResult = util.TraceLine(rTraceData)

        if lTraceResult.Hit then
            lEndPos = lTraceResult.HitPos
        end

        if rTraceResult.Hit then
            rEndPos = rTraceResult.HitPos

        end

        util.ParticleEffectTracer("vortigaunt_beam_charge", lClawAttach.Pos, lEndPos, self:GetAngles(), owner, "leftclaw")
        util.ParticleEffectTracer("vortigaunt_beam_charge", rClawAttach.Pos, rEndPos, self:GetAngles(), owner, "rightclaw")
    end

    function SWEP:StartDamageBeams(claws)
        local owner = self:GetOwner()
        local lClawAttach = owner:GetAttachment(owner:LookupAttachment("leftclaw"))
        local rClawAttach = owner:GetAttachment(owner:LookupAttachment("rightclaw"))

        local tr = owner:GetEyeTrace()

        if claws == CLAWS_LEFT then
            --util.ParticleEffectTracer("vortigaunt_beam", lClawAttach.Pos, tr.HitPos, owner:GetAngles(), owner, "leftclaw")
            util.ParticleTracerEx("vortigaunt_beam", lClawAttach.Pos, tr.HitPos, false, owner:EntIndex(), owner:LookupAttachment("leftclaw"))
        elseif claws == CLAWS_RIGHT then
            --util.ParticleEffectTracer("vortigaunt_beam", rClawAttach.Pos, tr.HitPos, owner:GetAngles(), owner, "rightclaw")
            util.ParticleTracerEx("vortigaunt_beam", rClawAttach.Pos, tr.HitPos, false, owner:EntIndex(), owner:LookupAttachment("rightclaw"))
        elseif claws == CLAWS_BOTH then
            --util.ParticleEffectTracer("vortigaunt_beam", lClawAttach.Pos, tr.HitPos, owner:GetAngles(), owner, "leftclaw")
            util.ParticleTracerEx("vortigaunt_beam", lClawAttach.Pos, tr.HitPos, false, owner:EntIndex(), owner:LookupAttachment("leftclaw"))
            util.ParticleTracerEx("vortigaunt_beam", rClawAttach.Pos, tr.HitPos, false, owner:EntIndex(), owner:LookupAttachment("rightclaw"))
            --util.ParticleEffectTracer("vortigaunt_beam", rClawAttach.Pos, tr.HitPos, owner:GetAngles(), owner, "rightclaw")
        end
    end

    hook.Add( "PlayerDisconnected", "VortlightCleanup", function(ply)
        local vortlightIndex = ply:GetNetVar("vortlight", nil)
        if vortlightIndex != nil then
            local vortlight = Entity(vortlightIndex)
            local dlight = DynamicLight(vortlightIndex)
            dlight.DieTime = CurTime()
    
            vortlight:Remove()
        else return end
    end )

    hook.Add( "EntityTakeDamage", "FormEnhanceDamageReduction", function( target, dmginfo )
        if ( target:IsPlayer() and dmginfo:IsExplosionDamage() ) then
            dmginfo:ScaleDamage( 0.5 ) // Damage is now half of what you would normally take.
        end
    end )
end

hook.Add("Think", "RestoreNPCFromStun", function()
    
    for k, v in pairs(ents.GetAll()) do
        if IsValid(v) and v:IsNPC() then
            local stunTime = v:GetVar("StunTime", -1)
            if stunTime != -1 and stunTime <= CurTime() then
                v:SetVar("StunTime", -1)
                v:SetVar("IsStunned", false)

                if SERVER then
                    v:SetNPCState(NPC_STATE_IDLE)
                end
            end
        end
    end
end)

local charMeta = ix.meta.character

function charMeta:GetVortPowerPercentage()

    if self:GetFaction() == FACTION_ALIEN and self:GetClass() != nil and self:GetClass() == CLASS_VORT then
        local vortType = self:GetData("vortTitle", "novice")

        if vortType == "novice" then
            return 0.65
        elseif vortType == "apprentice" then
            return 0.8
        elseif vortType == "adept" then
            return 1
        elseif vortType == "master" then
            return 1.25
        elseif vortType == "elder" then
            return 1.4
        elseif vortType == "secluded" then
            return 0
        elseif vortType == "proven" then
            return 1.4
        end
    else
        return 1
    end
end

function charMeta:ScaleWeaponValue(num)
    return num * self:GetVortPowerPercentage()
end

function charMeta:CanConsumeVortessence(amount)
    if self:GetPlayer():IsTranscendant() then
        return true
    else  
        local currentVortessence = self:GetVortessence()

        return (currentVortessence - amount) > 0 
    end
end

if SERVER then
    function charMeta:ConsumeVortessence(amount, isMirrored)
        if self:GetPlayer():IsTranscendant() then
            return -- do nothing
        else
            if !isMirrored then
                local vortShareInflictor = self:GetPlayer():GetNetVar("vortShareInflictor", -1)
                local vortShareRecipient = self:GetPlayer():GetNetVar("vortShareRecipient", -1)
    
                if vortShareInflictor != -1 then
                    vortShareInflictor = Entity(vortShareInflictor)
                    vortShareInflictor:GetCharacter():ConsumeVortessence(amount, true)
                elseif vortShareRecipient != -1 then
                    vortShareRecipient = Entity(vortShareRecipient)
                    vortShareRecipient:GetCharacter():ConsumeVortessence(amount, true)
                end
            end

            local currentVortessence = self:GetVortessence()
            local newVortessence = math.Clamp(currentVortessence - amount, 0, self:GetMaxVortessence())
            self:SetVortessence(newVortessence)
        end
    end

    function charMeta:AddVortessence(amount, isMirrored)
        if !isMirrored then
            local vortShareInflictor = self:GetPlayer():GetNetVar("vortShareInflictor", -1)
            local vortShareRecipient = self:GetPlayer():GetNetVar("vortShareInflictor", -1)

            if vortShareInflictor != -1 then
                vortShareInflictor = Entity(vortShareInflictor)
                vortShareInflictor:GetCharacter():AddVortessence(amount, true)
            elseif vortShareRecipient != -1 then
                vortShareRecipient = Entity(vortShareRecipient)
                vortShareRecipient:GetCharacter():AddVortessence(amount, true)
            end
        end

        local currentVortessence = self:GetVortessence()
        local newVortessence = math.Clamp(currentVortessence + amount, 0, self:GetMaxVortessence())
        self:SetVortessence(newVortessence)
    end
end

local entityMeta = FindMetaTable( "Entity" )

-- Gets the location(s) at which sprites are drawn for the entity's health.
-- Returns a table of vectors or nil if the entity is inorganic.
function entityMeta:GetHealthPosVectors() 
    local model = self:GetModel()

    local vectors = {}

    do
        if model == "models/zombie/classic.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
            vectors[2] = matrix2:GetTranslation()
        elseif model == "models/zombie/fast.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
            vectors[2] = matrix2:GetTranslation()
        elseif model == "models/zombie/poison.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
            vectors[2] = matrix2:GetTranslation()

            local bodygroups = self:GetBodyGroups()
            local prettyBodygroups = {}

            for key, bodygroupTable in pairs(bodygroups) do
                prettyBodygroups[bodygroupTable.name] = self:GetBodygroup(bodygroupTable.id) 
            end 

            if prettyBodygroups.headcrab2 == 1 then
                vectors[3] = matrix3:GetTranslation()
            end

            if prettyBodygroups.headcrab3 == 1 then
                vectors[4] = matrix4:GetTranslation()
            end

            if prettyBodygroups.headcrab4 == 1 then
                vectors[5] = matrix5:GetTranslation()
            end

            if prettyBodygroups.headcrab5 == 1 then
                vectors[6] = matrix6:GetTranslation()
            end
        elseif model == "models/zombie/classic_torso.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/zombie/fast_torso.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/headcrabclassic.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/headcrab.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/headcrabblack.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/antlion.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/antlion_guard.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/combine_strider.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/vortigaunt.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/combine_dropship.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/shield_scanner.mdl" then
            vectors[1] = self:GetPos()
        elseif model == "models/gunship.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/combine_helicopter.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/stalker.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model ==  "models/ichthyosaur_hlr.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/crow.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/pigeon.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/seagull.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/mortarsynth.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/synth.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/vortigaunt_blue.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/vortigaunt_slave.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/hunter.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/antlion_worker.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/barnacle.mdl" then
            vectors[1] = self:GetPos()
        elseif model == "models/antlion_grub.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/half-life/snark.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/half-life/kingpin.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/half-life/panthereye.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/opfor/voltigore.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/half-life/bullsquid.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/opfor/pit_drone.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/half-life/chumtoad.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/half-life/big_mom.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/opfor/strooper.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/opfor/shockroach.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/half-life/houndeye.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/half-life/baby_headcrab.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/opfor/gonome.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/half-life/kingpin.mdl" then
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()
            vectors[1] = matrix1:GetTranslation()
        elseif model == "models/decay/cockroach.mdl" then
            vectors[1] = self:GetPos()
        else
            local matrix1, matrix2, matrix3, matrix4, matrix5, matrix6 = self:GetHealBoneMatrices()

            if matrix1 == nil then 
                vectors[1] = self:GetPos() + Vector(0, 0, 60)
            else
                vectors[1] = matrix1:GetTranslation()
            end
        end
    end

    return vectors[1], vectors[2], vectors[3], vectors[4], vectors[5], vectors[6]
end

function entityMeta:GetHealthPosAngles() 
    local model = self:GetModel()

    local angles = {}

    do
        if model == "models/zombie/classic.mdl" then
            local boneID = self:LookupBone("ValveBiped.Bip01_Spine4")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end

            boneID = self:LookupBone("ValveBiped.HC_Body_Bone")
            angles[2] = self:GetBonePosition(boneID)
            if angles[2] == self:GetPos() then
                angles[2] = self:GetBoneMatrix(boneID):GetAngles()
            end
        elseif model == "models/zombie/fast.mdl" then
            local boneID = self:LookupBone("ValveBiped.Bip01_Spine4")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end

            boneID = self:LookupBone("ValveBiped.HC_BodyCube")
            angles[2] = self:GetBonePosition(boneID)
            if angles[2] == self:GetPos() then
                angles[2] = self:GetBoneMatrix(boneID):GetAngles()
            end
        elseif model == "models/zombie/poison.mdl" then
            local boneID = self:LookupBone("ValveBiped.Bip01_Spine4")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end

            boneID = self:LookupBone("ValveBiped.Headcrab_Cube1") -- we can just recycle the boneID variable because it's only used to get the original pos, which is already set at this point
            angles[2] = self:GetBonePosition(boneID)
            if angles[2] == self:GetPos() then
                angles[2] = self:GetBoneMatrix(boneID):GetAngles()
            end
            
            local bodygroups = self:GetBodyGroups()
            local prettyBodygroups = {}

            for key, bodygroupTable in pairs(bodygroups) do
                prettyBodygroups[bodygroupTable.name] = self:GetBodygroup(bodygroupTable.id) 
            end 

            if prettyBodygroups.headcrab2 == 1 then
                boneID = self:LookupBone("ValveBiped.Headcrab_Cube2")
                angles[3] = self:GetBonePosition(boneID)
                if angles[3] == self:GetPos() then
                    if (self:GetBoneMatrix(boneID) != nil) then
                        angles[3] = self:GetBoneMatrix(boneID):GetAngles()
                    end
                end
            end

            if prettyBodygroups.headcrab3 == 1 then
                boneID = self:LookupBone("ValveBiped.Headcrab_Cube3")
                angles[4] = self:GetBonePosition(boneID)
                if angles[4] == self:GetPos() then
                    if (self:GetBoneMatrix(boneID) != nil) then
                        angles[4] = self:GetBoneMatrix(boneID):GetAngles()
                    end
                end
            end

            if prettyBodygroups.headcrab4 == 1 then
                boneID = self:LookupBone("ValveBiped.Headcrab_Cube4")
                angles[5] = self:GetBonePosition(boneID)
                if angles[5] == self:GetPos() then
                    if (self:GetBoneMatrix(boneID) != nil) then
                        angles[5] = self:GetBoneMatrix(boneID):GetAngles()
                    end
                end
            end

            if prettyBodygroups.headcrab5 == 1 then
                boneID = self:LookupBone("ValveBiped.HC5_Bodybox")
                angles[6] = self:GetBonePosition(boneID)
                if angles[6] == self:GetPos() then
                    if (self:GetBoneMatrix(boneID) != nil) then
                        angles[6] = self:GetBoneMatrix(boneID):GetAngles()
                    end
                end
            end
            
        elseif model == "models/zombie/classic_torso.mdl" then
            local boneID = self:LookupBone("ValveBiped.Bip01_Spine2")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end
        elseif model == "models/zombie/fast_torso.mdl" then
            local boneID = self:LookupBone("ValveBiped.Bip01_Spine4")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end
        elseif model == "models/headcrabclassic.mdl" then
            local boneID = self:LookupBone("HeadcrabClassic.SpineControl")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end 
        elseif model == "models/headcrab.mdl" then
            local boneID = self:LookupBone("hcfast.body")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end 
        elseif model == "models/headcrabblack.mdl" then
            local boneID = self:LookupBone("hcblack.body")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end 
        elseif model == "models/antlion.mdl" then
            local boneID = self:LookupBone("Antlion.Body_Bone")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end
        elseif model == "models/antlion_guard.mdl" then
            local boneID = self:LookupBone("Antlion_Guard.body")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end
        elseif model == "models/combine_strider.mdl" then
            local boneID = self:LookupBone("Combine_Strider.Body_Bone")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end
        elseif model == "models/vortigaunt.mdl" then
            local boneID = self:LookupBone("ValveBiped.Spine3")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end 
        elseif model == "models/combine_dropship.mdl" then
            local boneID = self:LookupBone("D_ship.Spine1")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end
        elseif model == "models/shield_scanner.mdl" then
            angles[1] = angles[1]
        elseif model == "models/gunship.mdl" then
            local boneID = self:LookupBone("Gunship.Body")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end
        elseif model == "models/combine_helicopter.mdl" then
            local boneID = self:LookupBone("Chopper.Gun")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end
            angles[1] = angles[1] - Vector(0, 0, -65)
        elseif model == "models/stalker.mdl" then
            local boneID = self:LookupBone("ValveBiped.Bip01_Spine4")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end
        elseif model ==  "models/ichthyosaur_hlr.mdl" then
            local boneID = self:LookupBone("Ichthyosaur.Body_Bone")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end
        elseif model == "models/crow.mdl" then
            local boneID = self:LookupBone("Crow.Body")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end
        elseif model == "models/pigeon.mdl" then
            local boneID = self:LookupBone("Crow.Body")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end
        elseif model == "models/seagull.mdl" then
            local boneID = self:LookupBone("Seagull.Pelvis")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end
            angles[1] = angles[1] + Vector(0, 0, 1)
        elseif model == "models/mortarsynth.mdl" then
        elseif model == "models/synth.mdl" then
        elseif model == "models/vortigaunt_blue.mdl" then
            local boneID = self:LookupBone("ValveBiped.Spine3")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end 
        elseif model == "models/vortigaunt_slave.mdl" then
            local boneID = self:LookupBone("ValveBiped.Spine3")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end 
        elseif model == "models/vortigaunt_doctor.mdl" then
            local boneID = self:LookupBone("ValveBiped.Spine3")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end 
        elseif model == "models/hunter.mdl" then
        elseif model == "models/antlion_worker.mdl" then
            
        elseif model == "models/barnacle.mdl" then
            
        elseif model == "models/antlion_grub.mdl" then
        elseif model == "models/half-life/snark.mdl" then
            
        elseif model == "models/half-life/kingpin.mdl" then
        elseif model == "models/half-life/panthereye.mdl" then
            
        elseif model == "models/opfor/voltigore.mdl" then
            
        elseif model == "models/half-life/bullsquid.mdl" then
            
        elseif model == "models/opfor/pit_drone.mdl" then
            
        elseif model == "models/half-life/chumtoad.mdl" then
            
        elseif model == "models/half-life/big_mom.mdl" then
            
        elseif model == "models/opfor/strooper.mdl" then
            
        elseif model == "models/opfor/shockroach.mdl" then
            
        elseif model == "models/half-life/houndeye.mdl" then
            
        elseif model == "models/half-life/baby_headcrab.mdl" then
            
        elseif model == "models/opfor/gonome.mdl" then
            
        elseif model == "models/half-life/kingpin.mdl" then
        elseif model == "models/decay/cockroach.mdl" then
            
        else
            local boneID = self:LookupBone("ValveBiped.Bip01_Spine4")
            angles[1] = self:GetBonePosition(boneID)
            if angles[1] == self:GetPos() then
                angles[1] = self:GetBoneMatrix(boneID):GetAngles()
            end
        end
    end

    return angles[1], angles[2], angles[3], angles[4], angles[5], angles[6]
end

function entityMeta:IsOrganic()
    local INORGANICNPCS = {
        "models/combine_camera/combine_camera.mdl",
        "models/manhack.mdl",
        "models/combine_scanner.mdl",
        "models/roller.mdl",
        "models/roller_spikes.mdl",
        "models/roller_vehicledriver.mdl",
        "models/combine_turrets/floor_turret.mdl",
        "models/combine_turrets/ceiling_turret.mdl"
    }

    local isOrganic = true
    for k, v in ipairs(INORGANICNPCS) do 
        if v == self:GetModel() then
            isOrganic = false
            break
        end
    end

    return isOrganic
end

function entityMeta:CanVortHeal()
    local UNHEALABLENPCS = {
        "models/combine_camera/combine_camera.mdl",
        "models/manhack.mdl",
        "models/combine_scanner.mdl",
        "models/roller.mdl",
        "models/roller_spikes.mdl",
        "models/roller_vehicledriver.mdl",
        "models/combine_turrets/floor_turret.mdl",
        "models/combine_turrets/ceiling_turret.mdl",
        "models/Combine_Helicopter.mdl",
    }

    local canVortHeal = true
    for k, v in ipairs(UNHEALABLENPCS) do 
        if v == self:GetModel() then
            isOrganic = false
            break
        end
    end

    return canVortHeal
end

function entityMeta:GetHealthPosOffsets()
    local NOOFFSETS = {
        "models/zombie/fast.mdl",
        "models/zombie/poison.mdl",
        "models/headcrabclassic.mdl",
        "models/headcrab.mdl",
        "models/headcrabblack.mdl",
        "models/combine_strider.mdl",
        "models/ichthyosaur.mdl",
        "models/advisor.mdl",
        "models/antlion.mdl",
        "models/shield_scanner.mdl",
        "models/mortarsynth.mdl",
        "models/synth.mdl",
        "models/antlion_guard.mdl",
        "models/hunter.mdl",
        "models/antlion_grub.mdl",
        "models/half-life/bullsquid.mdl",
        "models/half-life/panthereye.mdl",
        "models/half-life/houndeye.mdl",
        "models/half-life/cockroach.mdl"
    }

    local offsets = {
        ["x"] = 0,
        ["y"] = 0,
        ["z"] = 0
    }

    local model = self:GetModel()

    for k, v in ipairs(NOOFFSETS) do
        if model == v then return offsets.x, offsets.y, offsets.z end
    end

    do
        if model == "models/zombie/classic.mdl" then
            offsets.x = 3
            offsets.y = 3
            offsets.z = -4
        elseif model == "models/zombie/classic_torso.mdl" then
            offsets.x = 4
            offsets.y = 4
        elseif model == "models/vortigaunt.mdl" then
            offsets.x = 3
            offsets.y = 3
            offsets.z = 3
        elseif model == "models/combine_dropship.mdl" then
            offsets.x = 15
            offsets.y = 15
        elseif model == "models/gunship.mdl" then
            offsets.x = 25
            offsets.y = 25
            offsets.z = -15
        elseif model == "models/combine_helicopter.mdl" then
            offsets.z = 60
        elseif model == "models/stalker.mdl" then
            offsets.x = 3
            offsets.y = 3
            offsets.z = -2
        elseif model == "models/crow.mdl" then
            offsets.x = 0
            offsets.y = 0
            offsets.z = 1
        elseif model == "models/pigeon.mdl" then
            offsets.x = 0
            offsets.y = 0
            offsets.z = 1
        elseif model == "models/seagull.mdl" then
            offsets.x = 3
            offsets.y = 3
            offsets.z = 2
        elseif model == "models/vortigaunt_blue.mdl" then
            offsets.x = 3
            offsets.y = 3
            offsets.z = 3
        elseif model == "models/vortigaunt_slave.mdl" then
            offsets.x = 3
            offsets.y = 3
            offsets.z = 3
        elseif model == "models/vortigaunt_doctor.mdl" then
            offsets.x = 3
            offsets.y = 3
            offsets.z = 3
        elseif model == "models/barnacle.mdl" then
            offsets.z = -15
        elseif model == "models/half-life/snark.mdl" then
            offsets.x = 4
            offsets.y = 4
        elseif model == "models/half-life/kingpin.mdl" then
        elseif model == "models/opfor/voltigore.mdl" then
            offsets.z = 25
        elseif model == "models/opfor/pit_drone.mdl" then
            offsets.x = -8
            offsets.y = -8
            offsets.z = 2
        elseif model == "models/half-life/chumtoad.mdl" then
            offsets.x = 3
            offsets.y = 3
            offsets.z = 0
        elseif model == "models/half-life/big_mom.mdl" then
            offsets.x = 50
            offsets.y = 50
        elseif model == "models/opfor/strooper.mdl" then
            offsets.x = 5
            offsets.y = 5
            offsets.z = -3
        elseif model == "models/opfor/shockroach.mdl" then
            offsets.x = -10
            offsets.y = -10
            offsets.z = -1
        elseif model == "models/half-life/baby_headcrab.mdl" then
            offsets.x = 3
            offsets.y = 3
            offsets.z = -2
        elseif model == "models/opfor/gonome.mdl" then
        elseif model == "models/half-life/kingpin.mdl" then
        elseif model == "models/decay/cockroach.mdl" then
        elseif model == "models/opfor/baby_voltigore.mdl" then
            offsets.z = 8
        elseif model == "models/half-life/zombie.mdl" then
        else
            offsets.x = 3
            offsets.y = 3
            offsets.z = -2
        end
    end

    return offsets.x, offsets.y, offsets.z
end

function entityMeta:GetHealBoneMatrices()
    local matrices = {}
    local model = self:GetModel()

    do
        if model == "models/zombie/classic.mdl" then
            local boneID = self:LookupBone("ValveBiped.Bip01_Spine4")
            matrices[1] = self:GetBoneMatrix(boneID)

            boneID = self:LookupBone("ValveBiped.HC_Body_Bone")
            matrices[2] = self:GetBoneMatrix(boneID)
            
        elseif model == "models/zombie/fast.mdl" then
            local boneID = self:LookupBone("ValveBiped.Bip01_Spine4")
            matrices[1] = self:GetBoneMatrix(boneID)

            boneID = self:LookupBone("ValveBiped.HC_BodyCube")
            matrices[2] = self:GetBoneMatrix(boneID)
        elseif model == "models/zombie/poison.mdl" then
            local boneID = self:LookupBone("ValveBiped.Bip01_Spine4")
            matrices[1] = self:GetBoneMatrix(boneID)

            boneID = self:LookupBone("ValveBiped.Headcrab_Cube1") -- we can just recycle the boneID variable because it's only used to get the original pos, which is already set at this point
            matrices[2] = self:GetBoneMatrix(boneID)
            
            local bodygroups = self:GetBodyGroups()
            local prettyBodygroups = {}

            for key, bodygroupTable in pairs(bodygroups) do
                prettyBodygroups[bodygroupTable.name] = self:GetBodygroup(bodygroupTable.id) 
            end 

            if prettyBodygroups.headcrab2 == 1 then
                boneID = self:LookupBone("ValveBiped.Headcrab_Cube2")
                matrices[3] = self:GetBoneMatrix(boneID)
            end

            if prettyBodygroups.headcrab3 == 1 then
                boneID = self:LookupBone("ValveBiped.Headcrab_Cube3")
                matrices[4] = self:GetBoneMatrix(boneID)
            end

            if prettyBodygroups.headcrab4 == 1 then
                boneID = self:LookupBone("ValveBiped.Headcrab_Cube4")
                matrices[5] = self:GetBoneMatrix(boneID)
            end

            if prettyBodygroups.headcrab5 == 1 then
                boneID = self:LookupBone("ValveBiped.HC5_Bodybox")
                matrices[6] = self:GetBoneMatrix(boneID)
            end
            
        elseif model == "models/zombie/classic_torso.mdl" then
            local boneID = self:LookupBone("ValveBiped.Bip01_Spine2")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/zombie/fast_torso.mdl" then
            local boneID = self:LookupBone("ValveBiped.Bip01_Spine4")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/headcrabclassic.mdl" then
            local boneID = self:LookupBone("HeadcrabClassic.SpineControl")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/headcrab.mdl" then
            local boneID = self:LookupBone("hcfast.body")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/headcrabblack.mdl" then
            local boneID = self:LookupBone("hcblack.body")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/antlion.mdl" then
            local boneID = self:LookupBone("Antlion.Body_Bone")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/antlion_guard.mdl" then
            local boneID = self:LookupBone("Antlion_Guard.body")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/combine_strider.mdl" then
            local boneID = self:LookupBone("Combine_Strider.Body_Bone")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/vortigaunt.mdl" then
            local boneID = self:LookupBone("ValveBiped.Spine3")
            matrices[1] = self:GetBoneMatrix(boneID) 
        elseif model == "models/combine_dropship.mdl" then
            local boneID = self:LookupBone("D_ship.Spine1")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/shield_scanner.mdl" then
            //we just use GetPos() for this
        elseif model == "models/gunship.mdl" then
            local boneID = self:LookupBone("Gunship.Body")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/combine_helicopter.mdl" then
            local boneID = self:LookupBone("Chopper.Gun")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/stalker.mdl" then
            local boneID = self:LookupBone("ValveBiped.Bip01_Spine4")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model ==  "models/ichthyosaur_hlr.mdl" then
            local boneID = self:LookupBone("Ichthyosaur.Body_Bone")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/crow.mdl" then
            local boneID = self:LookupBone("Crow.Body")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/pigeon.mdl" then
            local boneID = self:LookupBone("Crow.Body")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/seagull.mdl" then
            local boneID = self:LookupBone("Seagull.Pelvis")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/mortarsynth.mdl" then
            // we don't have a way to test this
        elseif model == "models/synth.mdl" then
            // we don't have a way to test this
        elseif model == "models/vortigaunt_blue.mdl" then
            local boneID = self:LookupBone("ValveBiped.Spine3")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/vortigaunt_slave.mdl" then
            local boneID = self:LookupBone("ValveBiped.Spine3")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/vortigaunt_doctor.mdl" then
            local boneID = self:LookupBone("ValveBiped.Spine3")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/hunter.mdl" then
            local boneID = self:LookupBone("MiniStrider.body_joint")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/antlion_worker.mdl" then
            local boneID = self:LookupBone("Antlion.Body_Bone")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/barnacle.mdl" then
            // The barnacle just uses GetPos()
        elseif model == "models/antlion_grub.mdl" then
            local boneID = self:LookupBone("antlionGrub.body")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/half-life/snark.mdl" then
            local boneID = self:LookupBone("Bip01 Spine")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/half-life/panthereye.mdl" then
            local boneID = self:LookupBone("Bip01 Spine2")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/opfor/voltigore.mdl" then
            local boneID = self:LookupBone("Bone01")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/half-life/bullsquid.mdl" then
            local boneID = self:LookupBone("Bip01 Pelvis")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/opfor/pit_drone.mdl" then
            local boneID = self:LookupBone("Bone18")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/half-life/chumtoad.mdl" then
            local boneID = self:LookupBone("MDLDEC_Bone10")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/half-life/big_mom.mdl" then
            local boneID = self:LookupBone("Bip01")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/opfor/strooper.mdl" then
            local boneID = self:LookupBone("Bip01 Spine2")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/opfor/shockroach.mdl" then
            local boneID = self:LookupBone("Bone28")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/half-life/houndeye.mdl" then
            local boneID = self:LookupBone("Bip01 Spine3")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/half-life/baby_headcrab.mdl" then
            local boneID = self:LookupBone("Bip01 Spine")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/opfor/gonome.mdl" then
            local boneID = self:LookupBone("Bip01 Spine2")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/half-life/kingpin.mdl" then
            local boneID = self:LookupBone("MDLDEC_Bone29")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/decay/cockroach.mdl" then
            // this just uses GetPos()
        elseif model == "models/opfor/baby_voltigore.mdl" then
            local boneID = self:LookupBone("Bone01")
            matrices[1] = self:GetBoneMatrix(boneID)
        elseif model == "models/half-life/zombie.mdl" then
            local boneID = self:LookupBone("Bip01 Spine3")
            matrices[1] = self:GetBoneMatrix(boneID)
        else
            local boneID = self:LookupBone("ValveBiped.Bip01_Spine4")

            if boneID != nil then
                matrices[1] = self:GetBoneMatrix(boneID)
            else
                matrices[1] = nil
            end
        end
    end

    return matrices[1], matrices[2], matrices[3], matrices[4], matrices[5], matrices[6]
end

function TryEndHealing(ent)
    for k, v in ipairs(player.GetAll()) do
        local healTarget = v:GetNetVar("HealTarget", -1)
        if healTarget != -1 and healTarget == ent:EntIndex() then
            v:GetActiveWeapon():EndHealing()
        end
    end
end

local playerMeta = FindMetaTable("Player")

function playerMeta:RemoveVortiLamp()
    local vortlightID = owner:GetNetVar("vortlight", -1)

    if vortlight == -1 then
        error("Attempt to remove vortilamp for player with no vortilamp!")
    else
        local vortlight = Entity(vortlightID)
        if SERVER then
            self:SetNetVar("vortlight", nil)
            vortlight:Remove()
            self:SetNetVar("LastVortilampConsump", nil)
        end
    end
end

function playerMeta:EndVortalEye()
    if SERVER then
        self:SetNetVar("xrayMode", false)
        self:SetNetVar("xrayShiftTimer", CurTime()) 
        self:SetNetVar("LastVortalEyeConsump", nil)
    end
end

function playerMeta:EnhanceForm(inflictor)
    self:EmitSound("weapons/physgun_off.wav", 75, 115)
    inflictor:EmitSound("weapons/physgun_off.wav", 75, 115)

    timer.Simple(0.85, function()
        local attachmentID = self:LookupAttachment("eyes")
        if attachmentID != 0 then -- if the attachment "eyes" is not invalid
            ParticleEffectAttach("vortigaunt_hand_glow", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("eyes"))
        else
            ParticleEffect("vortigaunt_hand_glow", self:GetPos() + Vector(0, 0, 72), Angle(0, 0, 0), self)
        end
    end)

    timer.Simple(0.85*2, function()
        self:StopParticles()
    end)

    local inflictorVortTitle = inflictor:GetCharacter():GetData("VortTitle", VORT_NOVICE)

    if inflictorVortTitle >= VORT_NOVICE then
        self:SetJumpPower(225)
    end

    if inflictorVortTitle >= VORT_APPRENTICE then
        self:SetRunSpeed(BASEENHANCEDRUNSPEED + self:GetCharacter():GetAttribute("agi", 0))
    end

    if SERVER then
        self:SetNetVar("FormEnhanced", inflictorVortTitle)
        self:SetNetVar("EnhanceFormInflictor", inflictor:EntIndex())

        inflictor:SetNetVar("EnhanceFormTarget", self:EntIndex())
    end
end

function playerMeta:UnenhanceForm()
    self:SetRunSpeed(ix.config.Get("runSpeed") + self:GetCharacter():GetAttribute("agi", 0))
    self:SetJumpPower(200)

    if SERVER then
        if self:GetNetVar("EnhanceFormInflictor", nil) then
            local inflictor = Entity(self:GetNetVar("EnhanceFormInflictor"))
            inflictor:SetNetVar("EnhanceFormTarget", nil)

            self:SetNetVar("FormEnhanced", nil)
            self:SetNetVar("EnhanceFormInflictor", nil)
        end
    end
end

function playerMeta:StopVortessenceShare()
    local target = Entity(self:GetNetVar("vortShareRecipient"))

    if SERVER then
        self:SetNetVar("vortShareRecipient", nil)
        target:SetNetVar("vortShareInflictor", nil)

        self:GetCharacter():SetMaxVortessence(200)
        target:GetCharacter():SetMaxVortessence(200)

        self:GetCharacter():SetVortessence(self:GetNetVar("originalVortessence"))
        target:GetCharacter():SetVortessence(target:GetNetVar("originalVortessence"))

        self:SetNetVar("originalVortessence", nil)
        target:SetNetVar("originalVortessence", nil)
    end
end

hook.Add("EntityRemoved", "EndVortigauntHealingOnRemove", function(ent)
    TryEndHealing(ent)
end)

hook.Add("player_disconnect", "EndVortigauntHealingOnDisconnect", function( data )
	local id = data.userid			// Same as Player:UserID()

    local disconnectedPlayer = Player(id)
    TryEndHealing(disconnectedPlayer)
end)  

hook.Add("player_disconnect", "FormEnhancementDCCleanup", function( data )
    local id = data.userid			// Same as Player:UserID()

    local ply = Player(id)

    if ply:GetNetVar("EnhanceFormTarget", nil) != nil then
        local enhanceFormTarget = Entity(ply:GetNetVar("EnhanceFormTarget"))
        ply:UnenhanceForm()
    elseif ply:GetNetVar("FormEnhanced", -1) != -1 then
        ply:UnenhanceForm() -- This is for the sake of uniformity. This should never do anything.
    end
end)

hook.Add( "PlayerDeath", "FormEnhanceDeathCleanup", function( victim, inflictor, attacker )
    if victim:GetNetVar("EnhanceFormTarget", nil) != nil then
        local enhanceFormTarget = Entity(victim:GetNetVar("EnhanceFormTarget"))
        victim:UnenhanceForm()
    elseif victim:GetNetVar("FormEnhanced", -1) != -1 then
        victim:UnenhanceForm()
    end
end )

hook.Add( "EntityTakeDamage", "FormEnhancementDamage", function( target, dmginfo )
	if ( target:IsPlayer() and target:GetNetVar("FormEnhanced", false)) then
        local DISCOUNTABLEDAMAGETYPES = {
            DMG_CLUB,
            DMG_SLASH
        }

        local dmgIsDiscountable = false

        for k, v in ipairs(DISCOUNTABLEDAMAGETYPES) do
            if dmginfo:GetDamageType() == v then
                dmgIsDiscountable = true
                break
            end
        end

        if dmgIsDiscountable and attacker:GetNetVar("FormEnhanced", false) >= VORT_APPRENTICE then
		    dmginfo:ScaleDamage( 0.8 ) // Damage is now half of what you would normally take.
        end
	end

    local attacker = dmginfo:GetAttacker()

    if ( attacker:IsPlayer() and attacker:GetNetVar("FormEnhanced", false)) then

        if dmginfo:GetDamageType() == DMG_CLUB and attacker:GetNetVar("FormEnhanced", false) >= VORT_APPRENTICE then
            dmginfo:ScaleDamage(1.2)
        end
    end
end )

hook.Add("AdjustStaminaOffset", "FormEnhancementStamina", function(client, offset)
    if client:GetNetVar("FormEnhanced", -1) >= VORT_APPRENTICE then
        return offset*0.5
    end
end)

hook.Add("PlayerLoadedCharacter", "VortigauntCleanup", function(client, oldChar, newChar)
    if client:GetNetVar("EnhanceFormTarget", nil) != nil then
        local enhanceFormTarget = Entity(ply:GetNetVar("EnhanceFormTarget"))
        client:UnenhanceForm()
    elseif client:GetNetVar("FormEnhanced", -1) != -1 then
        client:UnenhanceForm() -- This is for the sake of uniformity. This should never do anything.
    end
end)

if SERVER then

concommand.Add("reallyturnblue", function(ply, cmd, args, argStr)
    ply:Transcend()
end)

concommand.Add("reallyendblue", function(ply, cmd, args, argStr)
    ply:UnTranscend()
end)

end