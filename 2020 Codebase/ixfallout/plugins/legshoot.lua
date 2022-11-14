PLUGIN.name = "Legs wyjebnik"
PLUGIN.author = "Lechu2375"
PLUGIN.description = "Now hitting right in the legs causes injures."
PLUGIN.license =  "MIT not for use on Kaktusownia opensource.org/licenses/MIT"

if SERVER then
    local legs = {
        [HITGROUP_LEFTLEG] = true,
        [HITGROUP_RIGHTLEG] = true
    }
    --table with factions enums that should be resistant to these effects, you can find faction enum in the faction file
    --Example:
    /*
    local resFactions = {  
        [FACTION_OTA] = true,
        [FACTION_MPF] = true
    }
    */
    local resFactions = {

    }--fill this table

    function PLUGIN:ScalePlayerDamage(client, hitgroup, dmginfo)
        local char = client:GetCharacter()
        local inv = char:GetInventory()
        local items = inv:GetItems()
        local lck = char:GetAttribute("lck", 0)
        local lckMult = ix.config.Get("luckMultiplier", 1)
        local stm = char:GetAttribeute("stm", 0)

        if char then
            if resFactions[char:GetFaction()] then return end

            if items then
                for k, v in pairs(items) do
                    if (v:GetData("equip") == true and v.base == "base_armor") then
                        local durability = v:GetData("Durability", 100)

                        if (durability > 0) then
                            return
                        end
                    end
                end
            end

            if legs[hitgroup] then
                local chance = math.random(1,100)

                if (lck and lckMult) then
                    chance = math.Clamp(chance - lck * lckMult, 1, 100)
                end

                if stm then
                    chance = math.Clamp(chance - stm, 1, 100)
                end

                if (chance <= 40) then
                    client:SetRagdolled(true, 10)
                end
            end
        end
    end
end