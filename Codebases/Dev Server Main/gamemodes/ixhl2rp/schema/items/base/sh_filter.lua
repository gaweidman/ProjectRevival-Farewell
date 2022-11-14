ITEM.name = "Gas Mask Filter"

ITEM.model = "models/illusion/eftcontainers/nixxorlens.mdl"

ITEM.description = "A regular gas mask filter."

ITEM.category = "Equipment"

ITEM.durability = 5000

ITEM.functions.equip = {
    name = "Equip",
    tip = "Put the filter on your gas mask.",
    icon = "icon16/plugin.png",
    OnRun = function(item)
        local client = item.player

        if (client:GetCharacter():GetData("gasmask", nil) != nil) then
            local inv = client:GetCharacter():GetInventory()

            local gasmaskItem = inv:HasItem(client:GetCharacter():GetData("gasmask", nil), {
                ["equip"] = true
            })

            gasmaskItem:SetData("filterDurability", item.durability)
            gasmaskItem:SetData("maxFilterDurability", item.durability)
        end
    end,

    OnCanRun = function(item)
        return item.player:GetCharacter():GetData("gasmask", nil) != nil and item.player:GetCharacter():GetData("gasmask", nil) != false
    end
}