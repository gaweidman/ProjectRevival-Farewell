local entityMeta = FindMetaTable("Entity")

function entityMeta:IsOneHanded()
    if !self:IsWeapon() then return nil end

    local holdType = self:GetHoldType()

    return holdType == "pistol" or holdType == "grenade" or holdType == "revolver"
end

function entityMeta:IsTwoHanded()
    return !self:IsOneHanded()
end