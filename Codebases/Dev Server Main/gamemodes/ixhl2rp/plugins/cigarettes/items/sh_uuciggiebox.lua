
ITEM.name = "UU Brand Cigarette Pack"
ITEM.model = Model("models/closedboxshit.mdl")
ITEM.description = "A blue and white pack of cigarettes with a lighting strip on the back."

ITEM.functions.Take = {
	OnRun = function(itemTable)
		local client = itemTable.player
        local character = client:GetCharacter()

        if (itemTable:GetData("cigcount", -1) == -1) then
            itemTable:SetData("cigcount", 10)
        end

        if (itemTable:GetData("cigcount", -1) > 0) then
            if (!character:GetInventory():Add("uuciggie")) then
                ix.item.Spawn("uuciggie", client)
            end
            client:EmitSound("physics/cardboard/cardboard_box_impact_hard6.wav", 75, math.random(160, 180), 0.35)
            itemTable:SetData("cigcount", itemTable:GetData("cigcount", -1) - 1)
            cigCount = itemTable:GetData("cigcount", -1)
        end

        if (itemTable:GetData("cigcount", -1) <= 0) then
            client:Notify("This pack is empty!")
            
        end
        
        return false
    end
    
}

ITEM.functions.View = {
	OnRun = function(itemTable)
		local client = itemTable.player
        
        client:Notify("There are ".. itemTable:GetData("cigcount", -1) .." cigarettes left in the pack.")

        return false
    end
    
}

/*
function ITEM:PopulateTooltip(tooltip)
    local tip = tooltip:AddRow("cigs")
    print(self.cigCount)
    tip:SetBackgroundColor(Color(137, 137, 137))
    tip:SetText("There are "..self.cigCount.." cigarettes left in the pack.")
    tip:SetFont("DermaDefault")
    tip:SizeToContents()
end
*/
