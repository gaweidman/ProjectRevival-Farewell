PLUGIN.name = "Clothing Base"
PLUGIN.description = "Adds a clothing base and some clothing items"
PLUGIN.author = "Stalker"

do
    local ITEM = ix.item.Register("base_clothing", nil, true, nil, true)
    
    ITEM.name = "Outfit"
    ITEM.description = "A Outfit Base."
    ITEM.category = "Outfit"
    ITEM.model = "models/Gibs/HGIBS.mdl"
    ITEM.width = 1
    ITEM.height = 1
    ITEM.outfitCategory = "model"
    ITEM.pacData = {}

    --[[
    -- This will change a player's skin after changing the model. Keep in mind it starts at 0.
    ITEM.newSkin = 1
    -- This will change a certain part of the model.
    ITEM.replacements = {"group01", "group02"}
    -- This will change the player's model completely.
    ITEM.replacements = "models/manhack.mdl"
    -- This will have multiple replacements.
    ITEM.replacements = {
        {"male", "female"},
        {"group01", "group02"}
    }

    -- This will apply body groups.
    ITEM.bodyGroups = {
        ["blade"] = 1,
        ["bladeblur"] = 1
    }
    ]]--

    -- Inventory drawing
    if (CLIENT) then
        function ITEM:PaintOver(item, w, h)
            if (item:GetData("equip")) then
                surface.SetDrawColor(110, 255, 110, 100)
                surface.DrawRect(w - 14, h - 14, 8, 8)
            end
        end
    end

    function ITEM:RemoveOutfit(client)
        local character = client:GetCharacter()

        self:SetData("equip", false)

        if (character:GetData("oldModel" .. self.outfitCategory)) then
            character:SetModel(character:GetData("oldModel" .. self.outfitCategory))
            character:SetData("oldModel" .. self.outfitCategory, nil)
        end

        if (self.newSkin) then
            if (character:GetData("oldSkin" .. self.outfitCategory)) then
                client:SetSkin(character:GetData("oldSkin" .. self.outfitCategory))
                character:SetData("oldSkin" .. self.outfitCategory, nil)
            else
                client:SetSkin(0)
            end
        end

        for k, _ in pairs(self.bodyGroups or {}) do
            local index = client:FindBodygroupByName(k)

            if (index > -1) then
                client:SetBodygroup(index, 0)

                local groups = character:GetData("groups", {})

                if (groups[index]) then
                    groups[index] = nil
                    character:SetData("groups", groups)
                end
            end
        end

        -- restore the original bodygroups
        if (character:GetData("oldGroups" .. self.outfitCategory)) then
            for k, v in pairs(character:GetData("oldGroups" .. self.outfitCategory, {})) do
                client:SetBodygroup(k, v)
            end

            character:SetData("groups", character:GetData("oldGroups" .. self.outfitCategory, {}))
            character:GetData("oldGroups" .. self.outfitCategory, nil)
        end

        if (self.attribBoosts) then
            for k, _ in pairs(self.attribBoosts) do
                character:RemoveBoost(self.uniqueID, k)
            end
        end

        for k, _ in pairs(self:GetData("outfitAttachments", {})) do
            self:RemoveAttachment(k, client)
        end

        self:OnUnequipped()
    end

    -- makes another outfit depend on this outfit in terms of requiring this item to be equipped in order to equip the attachment
    -- also unequips the attachment if this item is dropped
    function ITEM:AddAttachment(id)
        local attachments = self:GetData("outfitAttachments", {})
        attachments[id] = true

        self:SetData("outfitAttachments", attachments)
    end

    function ITEM:RemoveAttachment(id, client)
        local item = ix.item.instances[id]
        local attachments = self:GetData("outfitAttachments", {})

        if (item and attachments[id]) then
            item:OnDetached(client)
        end

        attachments[id] = nil
        self:SetData("outfitAttachments", attachments)
    end

    ITEM:Hook("drop", function(item)
        if (item:GetData("equip")) then
            item:RemoveOutfit(item:GetOwner())
        end
    end)

    ITEM.functions.EquipUn = { -- sorry, for name order.
        name = "Unequip",
        tip = "equipTip",
        icon = "icon16/cross.png",
        OnRun = function(item)
            item:RemoveOutfit(item.player)
            return false
        end,
        OnCanRun = function(item)
            local client = item.player

            return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and
                hook.Run("CanPlayerUnequipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
        end
    }

    ITEM.functions.Equip = {
        name = "Equip",
        tip = "equipTip",
        icon = "icon16/tick.png",
        OnRun = function(item)
            local client = item.player
            local char = client:GetCharacter()
            local items = char:GetInventory():GetItems()

            for _, v in pairs(items) do
                if (v.id != item.id) then
                    local itemTable = ix.item.instances[v.id]

                    if (itemTable.pacData and v.outfitCategory == item.outfitCategory and itemTable:GetData("equip")) then
                        client:NotifyLocalized(item.equippedNotify or "outfitAlreadyEquipped")
                        return false
                    end
                end
            end

            item:SetData("equip", true)

            if (isfunction(item.OnGetReplacement)) then
                char:SetData("oldModel" .. item.outfitCategory, char:GetData("oldModel" .. item.outfitCategory, item.player:GetModel()))
                char:SetModel(item:OnGetReplacement())
            elseif (item.replacement or item.replacements) then
                char:SetData("oldModel" .. item.outfitCategory, char:GetData("oldModel" .. item.outfitCategory, item.player:GetModel()))

                if (istable(item.replacements)) then
                    if (#item.replacements == 2 and isstring(item.replacements[1])) then
                        char:SetModel(item.player:GetModel():gsub(item.replacements[1], item.replacements[2]))
                    else
                        for _, v in ipairs(item.replacements) do
                            char:SetModel(item.player:GetModel():gsub(v[1], v[2]))
                        end
                    end
                else
                    char:SetModel(item.replacement or item.replacements)
                end
            end

            if (item.newSkin) then
                char:SetData("oldSkin" .. item.outfitCategory, item.player:GetSkin())
                item.player:SetSkin(item.newSkin)
            end

            local groups = char:GetData("groups", {})

            if (!table.IsEmpty(groups)) then
                char:SetData("oldGroups" .. item.outfitCategory, groups)

                if (!item.bNoBodygroupReset) then
                client:ResetBodygroups()
                end
            end

            if (item.bodyGroups) then
                groups = {}

                for k, value in pairs(item.bodyGroups) do
                    local index = item.player:FindBodygroupByName(k)

                    if (index > -1) then
                        groups[index] = value
                    end
                end

                local newGroups = char:GetData("groups", {})

                for index, value in pairs(groups) do
                    newGroups[index] = value
                    item.player:SetBodygroup(index, value)
                end

                if (!table.IsEmpty(newGroups)) then
                    char:SetData("groups", newGroups)
                end
            end

            if (item.attribBoosts) then
                for k, v in pairs(item.attribBoosts) do
                    char:AddBoost(item.uniqueID, k, v)
                end
            end

            item:OnEquipped()
            return false
        end,
        OnCanRun = function(item)
            local client = item.player

            return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true and item:CanEquipOutfit() and
                hook.Run("CanPlayerEquipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
        end
    }

    function ITEM:CanTransfer(oldInventory, newInventory)
        if (newInventory and self:GetData("equip")) then
            return false
        end

        return true
    end

    function ITEM:OnRemoved()
        if (self.invID != 0 and self:GetData("equip")) then
            self.player = self:GetOwner()
                self:RemoveOutfit(self.player)
            self.player = nil
        end
    end

    function ITEM:OnEquipped()
    end

    function ITEM:OnUnequipped()
    end

    function ITEM:CanEquipOutfit()
        return true
    end

end

local ITEMS = {}
ITEMS["reinforced_civshirt"] = {
    name = "Reinforced Citizen Shirt",
    description = "A standard citizen shirt covertly lined with kevlar.",
    model = "models/tnb/items/shirt_citizen1.mdl",
    width = 1,
    height = 1,
    dt = DTTable(0, 0, 3, 1, 0, 0),
    bodyGroups = {
        torso = 0
    },
    outfitCategory = "torso",
    bNoBodygroupReset = true
}

ITEMS["xreinforced_civshirt"] = {
    name = "Reinforced Citizen Shirt",
    description = "A standard citizen shirt covertly lined with both kevlar and scrap metal.",
    model = "models/tnb/items/shirt_citizen1.mdl",
    width = 1,
    height = 1,
    dt = DTTable(4, 2, 3, 1, 1, 3),
   
    bodyGroups = {
        torso = 0
    },
    outfitCategory = "torso",
    bNoBodygroupReset = true,
}

ITEMS["ccavest"] = {
    name = "CCA Vest",
    description = "A kevlar vest meant to cover the upper torso, rolled out to CCA units.",
    model = "models/tnb/items/shirt_rebelmetrocop.mdl",
    width = 1,
    height = 1,
    skin = 1,
    dt = DTTable(0, 2, 5, 1, 1, 0),
    bodyGroups = {
        torso = 5
    },
    outfitCategory = "torso",
    bNoBodygroupReset = true,
}

ITEMS["armorpants"] = {
    name = "Reinforced Citizen Pants",
    description = "A pair of citizen pants reinforced with kevlar.",
    model = "models/tnb/items/pants_rebel.mdl",
    width = 1,
    height = 1,
    skin = 0,
    dt = DTTable(0, 0, 2, 0, 1, 0),
    bodyGroups = {
        legs = 4
    },
    outfitCategory = "legs",
    bNoBodygroupReset = true,
}

ITEMS["antlionarmor"] = {
    name = "Antlion Armor",
    description = "A set of antlion carapace pieces with straps on them, meant to be worn as armor.",
    model = "models/tnb/items/pants_rebel.mdl",
    width = 1,
    height = 1,
    skin = 0,
    dt = DTTable(5, 4, 8, 0, 2, 4),
    bodyGroups = {
        legs = 4
    },
    outfitCategory = "model",
    bNoBodygroupReset = true,
}

ITEMS["syntharmor"] = {
    name = "Synth Armor",
    description = "A assembly of beige synth plating modified to cover vital organs and limbs.",
    model = "models/gibs/shield_scanner_gib3.mdl",
    width = 2,
    height = 2,
    skin = 0,
    dt = DTTable(8, 6, 15, 12, 8, 6),
    outfitCategory = "model",
    bNoBodygroupReset = true,
}



for uniqueID, itemTbl in pairs(ITEMS) do
    local ITEM = ix.item.Register(uniqueID, "base_clothing", false, nil, true)
    for key, value in pairs(itemTbl) do
        if key != "functions" then
            ITEM[key] = value
        else
            for funcId, tbl in pairs(value) do
                ITEM.functions[funcId] = tbl
            end
        end
    end
end
