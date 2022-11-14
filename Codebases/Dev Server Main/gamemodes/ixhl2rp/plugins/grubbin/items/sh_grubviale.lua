ITEM.name = "Empty Antlion Grub Vial"
ITEM.description = "A plexiglass tank with tracks on the inside."
ITEM.category = "Junk"
ITEM.model = "models/ccr/props/grub_vial.mdl"
ITEM.width = 1
ITEM.height = 1

-- This doesn't work because ragdolls as items don't work, and there's no living antlion grub prop.
--[[
ITEM.functions.Empty = {
    sound = "weapons/crossbow/reload1.wav",
    OnRun = function(itemTable)
        
        local client = itemTable.player
        local character = client:GetCharacter()
        local inventory = character:GetInventory()

        if (!inventory:Add("grubvialf")) then
            ix.item.Spawn("grubvialf", client)
        end

        if (!inventory:Add("livingGrub")) then
            ix.item.Spawn("livingGrub", client)
        end
    end
}
]]--