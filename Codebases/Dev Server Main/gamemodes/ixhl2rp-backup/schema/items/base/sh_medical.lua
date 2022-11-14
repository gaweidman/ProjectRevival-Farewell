ITEM.name = "Medical Base"
ITEM.model = "models/Items/HealthKit.mdl"
ITEM.description = "A medical item."
ITEM.category = "Medical"
ITEM.sound = "ccr/syringe/health_pen.mp3"
ITEM.healAmount = 20

ITEM.functions.AHealSelf = {
    name = "Heal Self",
    icon = "icon16/user.png",
    OnRun = function(item)
        local ply = item.player
        
        if ply:Health() >= ply:GetMaxHealth() then
            ply:Notify("Your health is already full!")
            return false
        else
            ply:EmitSound(item.sound)
            ply:Heal(Lerp(ply:GetCharacter():GetSkill("medical")/100, item.healAmount*1.3, item.healAmount*0.8))
        end 
    end
}

ITEM.functions.HealOther = {
    name = "Heal Other",
    icon = "icon16/group.png",
    OnRun = function(item)
        local ply = item.player
        local target = ply:GetEyeTrace().Entity

        if IsValid(target) and target:IsPlayer() then
            if target:Health() >= target:GetMaxHealth() then
                ply:Notify("This person's health is already full!")
                return false
            else
                target:EmitSound(item.sound)
                target:Heal(Lerp(ply:GetCharacter():GetSkill("medical")/100, item.healAmount*1.3, item.healAmount*0.8))
                return true
            end
        else
            ply:Notify("You are not looking at a valid player!")
            return false
        end
    end
}

