ix.illness = {}

ix.illness.sporeTypes = {
    ["lungSpore"] = {
        name = "Xenotherus Erethipleura",
        randomEffects = {
            function(client)
                client:EmitSound("ambient/voices/cough"..math.random(1, 4)..".wav")
                client:Notify("You cough.")
            end,
            function(client)
                client:Notify("You suddenly feel winded.")
                -- Take some of the player's stamina.
            end
        },
        baseEffects = {
            stamina = 0.75
        },
        treatments = {},
        cures = {}
    },
    ["kidnerySpore"] = {
        name = "Xenotherus Glomerulonephrita",
        randomEffects = {
            function(client) 
                client:Puke()
                local char = client:GetCharacter()
                char:SetHunger(char:GetHunger() - 20)
            end
        },
        treatments = {},
        cures = {}
    },
    ["bloodSpore"] = {
        name = "Xenotherus Hemoffingera",
        randomEffects = {
            function(client) 
                client:Notify("You feel unusually sweaty.")
            end
        },
        baseEffects = {
            thirstDecay = 1.2
        },
        treatments = {},
        cures = {}
    },
    ["debugSporeOne"] = {
        name = "Xenotherus TODO",
        randomEffects = {
            function(client) 
                
            end
        },
        baseEffects = {},
        treatments = {},
        cures = {}
    },
    ["debugSporeTwo"] = {
        name = "Xenotherus TODO",
        randomEffects = {
            function(client) 
                
            end
        },
        baseEffects = {},
        treatments = {},
        cures = {}
    },
}

ix.inventory.Register("decontamChamber", 8, 7, false)

local charMeta = ix.meta.character

function charMeta:AddIllness(illness, stage, ignoreIncubation, ignoreDuplicate)
    local illnessTbl = self:GetData("Illnesses", {})

    if illnessTbl[illness.uniqueID]and !ignoreDuplicate then
        return
    else
        illnessTbl[illness.uniqueID] = {
            contractTime = os.time(),
            incubationTime = ignoreIncubation and os.time() or os.time() + 1440*math.random(1, 3),
            growthStage = stage or 1
        }
    end
end

local playerMeta = FindMetaTable("Player")
function playerMeta:Puke()
    self:Notify("You feel yourself begin to heave.")
    self:ForceSequence("d2_coast03_postbattle_idle02")
    local pukeSounds = {"ambient/voices/citizen_beaten3.wav", "ambient/voices/citizen_beaten4.wav"}
    local splashSounds = {"physics/flesh/flesh_squishy_impact_hard1.wav", "physics/flesh/flesh_squishy_impact_hard2.wav", "physics/flesh/flesh_squishy_impact_hard3.wav", "physics/flesh/flesh_squishy_impact_hard4.wav"}
    timer.Simple(0.1, function()
        local pukeSound = pukeSounds[math.random(1, #pukeSounds)]
        self:EmitSound(pukeSound)

        timer.Simple(SoundDuration(pukeSound), function()
            self:EmitSound(splashSounds[math.random(1, #splashSounds)])
            local bonePos = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Head1"))
            local angles = self:GetAngles()
            angles.x = 0
            angles.z = 0

            local forward = angles:Forward()
            print(util.QuickTrace(bonePos + forward*15 + Vector(0, 0, 5), self:GetPos() + forward*15 + Vector(0, 0, -5)).Entity)
            local decalPos = self:GetPos() + forward*18
            util.Decal("YellowBlood", decalPos + Vector(0, 0, 5), decalPos + Vector(0, 0, -5))
        end)
    end)
end 