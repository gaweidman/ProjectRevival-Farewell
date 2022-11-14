PLUGIN.name = "Money Kill"
PLUGIN.author = "Stan, Frosty"
PLUGIN.description = "Allows the player to earn money from killing NPCs and players"

ix.config.Add("NPCKillAmount", 10, "How much money a player gets for killing an NPC", nil, {
	data = {min = 0, max = 1000},
	category = "moneykill"
})

ix.config.Add("PlayerKillAmount", 5, "How much money a player gets for killing a player.", nil, {
    data = {min = 0, max = 1000},
    category = "moneykill"
})

ix.lang.AddTable("english", {
    moneykill = "Money Kill",
    MoneyKillEarned = "You have recived %s for killing.",
})

ix.lang.AddTable("korean", {
    moneykill = "처치 보상",
    MoneyKillEarned = "처치 보상으로 %s을(를) 받았습니다.",
})

function PLUGIN:OnNPCKilled(victim, ent, weapon)
    -- If something killed the npc
    if not ent then return end

    if ent:IsVehicle() and ent:GetDriver():IsPlayer() then ent = ent:GetDriver() end

    local money = math.random(0, ix.config.Get("NPCKillAmount"))

    if IsValid(ent) and ent:IsPlayer() and ent:GetCharacter() then
        if ent:GetCharacter():GetAttribute("lck", 0) then
            money = money + ix.config.Get("luckMultiplier") * ent:GetCharacter():GetAttribute("lck", 0)
        else end
    end

    -- If we know by now who killed the NPC, pay them.
    if IsValid(ent) and ent:IsPlayer() and ix.config.Get("NPCKillAmount") > 0 and money > 0 then
        local char = ent:GetCharacter()
        char:GiveMoney(money)
        char.player:NotifyLocalized("MoneyKillEarned", ix.currency.Get(money))
    end
end

function PLUGIN:DoPlayerDeath(victim, ent, dmg)
    if not ent then return end
    if ent:IsVehicle() and ent:GetDriver():IsPlayer() then ent = ent:GetDriver() end

    local money = math.random(0, ix.config.Get("PlayerKillAmount"))

    if IsValid(ent) and ent:IsPlayer() and ent:GetCharacter() then
        if ent:GetCharacter():GetAttribute("lck", 0) then
            money = money + ix.config.Get("luckMultiplier") * ent:GetCharacter():GetAttribute("lck", 0)
        else end
    end

    if IsValid(ent) and ent:IsPlayer() and ix.config.Get("PlayerKillAmount") > 0 and money > 0 and (ent != victim) then
        local char = ent:GetCharacter()
        char:GiveMoney(money)
        char.player:NotifyLocalized("MoneyKillEarned", ix.currency.Get(money))
    end
end
