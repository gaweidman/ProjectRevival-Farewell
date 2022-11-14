local PLUGIN = PLUGIN;

PLUGIN.name = "NPC Drop"
PLUGIN.author = "Mixed"
PLUGIN.description = "Makes NPC Drop items when they die."

function PLUGIN:OnNPCKilled(entity, attacker, inflictor)
    local class = entity:GetClass()
    
    -- Zombie Stuff
    if (class == "npc_zombie") then
        local rand = math.random(1, 50)
    	if rand == 1 or rand == 2 or rand == 3 or rand == 4 or rand == 5 then
        	ix.item.Spawn("aabattery", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 6 then
            ix.item.Spawn("pliers", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 7 or rand == 8 or rand == 9 then
            ix.item.Spawn("powercord", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 10 or rand == 11 or rand == 12 or rand == 13 then
            ix.item.Spawn("soap", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 14 then
            ix.item.Spawn("wrench", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 15 or rand == 16 or rand == 17 then
            ix.item.Spawn("screwpack", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 18 or rand == 19 or rand == 20 then
            ix.item.Spawn("nailpack", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 21 or rand == 22 or rand == 23 then
            ix.item.Spawn("wires", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 24 or rand == 25 then
            ix.item.Spawn("prewarblueshirt", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 26 or rand == 27 or rand == 28 then
            ix.item.Spawn("fingerlessgloves", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 29 then
            ix.item.Spawn("padlock", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 30 or rand == 31 or rand == 32 then
            ix.item.Spawn("cloth_scrap", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 33 or rand == 34 or rand == 35 then
            ix.item.Spawn("scrap_metal", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 33 or rand == 34 then
            ix.item.Spawn("sewn_cloth", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 35 or rand == 36 or rand == 37 or rand == 38 then
            ix.item.Spawn("empty_paint_can", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 33 or rand == 34 or rand == 35 then
            ix.item.Spawn("scrap_metal", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 36 then
            ix.currency.Spawn(entity:GetPos() + Vector(0, 0, 8), 15)
        elseif rand == 37 or rand == 38 or rand == 39 then
            ix.currency.Spawn(entity:GetPos() + Vector(0, 0, 8), 5)
        end
    end

    -- Zombine Stuff
    -- Players don't have entity indexes, so we have to use this check here.
    if (class == "npc_zombine" and attacker:IsPlayer()) then
        local rand = math.random(1, 16)
    	if rand == 1 or rand == 2 then
        	ix.item.Spawn("pistolammo", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 3 or rand == 4 or rand == 5 or rand == 6 then
            ix.item.Spawn("ar2ammo", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 7 or rand == 8 or rand == 9 or rand == 10 then
            ix.item.Spawn("shotgunammo", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 11 or rand == 12 or rand == 13 then
            ix.item.Spawn("smg1ammo", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 14 or rand == 15 then
            ix.item.Spawn("357ammo", entity:GetPos() + Vector(0, 0, 8))
        elseif rand == 16 then
            ix.item.Spawn("flashlight", entity:GetPos() + Vector(0, 0, 8))
        end
    end

    if (class == "npc_fastzombie") then
        local rand = math.random(1, 8)
        if rand == 1 or rand == 2 or rand == 3 then
            ix.currency.Spawn(entity:GetPos() + Vector(0, 0, 8), 10)
        elseif rand == 4 or rand == 5 or rand == 6 then
            ix.currency.Spawn(entity:GetPos() + Vector(0, 0, 8), 20)
        end
    end

    if (class == "npc_poisonzombie") then
        local rand = math.random(1, 10)
        if rand == 1 or rand == 2 or rand == 3 then
            ix.currency.Spawn(entity:GetPos() + Vector(0, 0, 8), 20)
        elseif rand == 4 or rand == 5 or rand == 6 then
            ix.currency.Spawn(entity:GetPos() + Vector(0, 0, 8), 30)
        elseif rand == 6 or rand == 7 then
            ix.item.Spawn("padlock", entity:GetPos() + Vector(0, 0, 8))
        end
    end
end