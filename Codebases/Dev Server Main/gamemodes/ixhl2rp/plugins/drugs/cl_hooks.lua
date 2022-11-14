function PLUGIN:RenderScreenspaceEffects()
    local client = LocalPlayer()
    local character = client:GetCharacter()

    if (!character) then
        return
    end

    local drug = ix.item.list[character:GetDrug()]

    local drugStr = client:GetNetVar("drug")

    if (!drug) then return end

    --if (!drug.screenspaceEffects) then return end
    if (drug.screenspaceEffects) then
        drug.screenspaceEffects()
    end
    --drug.screenspaceEffects()
end