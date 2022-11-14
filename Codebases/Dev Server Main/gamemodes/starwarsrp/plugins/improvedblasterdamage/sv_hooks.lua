hook.Add("EntityTakeDamage", "DamageResistance", function(target, dmginfo) 

    --[[

    if (!target:IsPlayer()) then return end -- This code only works for players.
    
    local faction = target:GetCharacter():GetFaction()
    local class = target:GetCharacter():GetClass()

    if (faction == FACTION_DROID and dmginfo:GetInflictor():GetClass() == "23v_lafette" or string.find(dmginfo:GetAttacker():GetActiveWeapon():GetClass(), "rw_sw_")) then
        dmginfo:SetDamage(1)
    end

    ]]--

end)
