ITEM.name = "UU Brand Cigarette"
ITEM.model = Model("models/phycitnew.mdl")
ITEM.description = "A blue and white cigarette with a combine emblem on it."

ITEM.functions.Smoke = {
    OnRun = function(itemTable)
        local client = itemTable.player
        local hascigbox = false
        
        for _, uniqueID in pairs(client:GetCharacter():GetInventory()) do
            //print(ix.item.Get(uniqueID):GetName())
            if (client:GetCharacter():GetInventory():HasItem("uuciggiebox")) then
                hascigbox = true
            end
        end

        if (hascigbox) then
            client:SetHealth(math.Clamp(client:Health() + 1, 0, client:GetMaxHealth()))
            client:EmitSound("ambient/fire/gascan_ignite1.wav", 50, 150, 0.25)
            
            return true
        else
            client:Notify("You need a UU Brand Cigarette pack to light this!")
            return false
        end
	end
}
