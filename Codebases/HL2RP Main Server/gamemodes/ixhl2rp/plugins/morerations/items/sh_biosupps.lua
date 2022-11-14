ITEM.name = "Biotic Grade Supplements"
ITEM.model = Model("models/mres/consumables/lag_mre.mdl")
ITEM.description = "A green and white packet containing a foul-tasting paste."

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player

		if (ix.faction.Get(client:Team()).name == "Vortigaunt") then
			client:SetHealth(math.Clamp(client:Health() + 40, 0, client:GetMaxHealth()))
			client:EmitSound("npc/antlion_grub/squashed.wav", 75, 150, 0.25)
		else
			client:SetHealth(math.Clamp(client:Health() - 10, 0, client:GetMaxHealth()))
			if (client:Health() <= 0) then
				client:Kill()
			end
		end

		
		client:EmitSound("npc/antlion_grub/squashed.wav", 75, 150, 0.25)
	end,
	OnCanRun = function(itemTable)
		//return !itemTable.player:HasBiosignal()
	end
}

function ITEM:PopulateTooltip(tooltip)
	local tip = tooltip:AddRow("warning")
    tip:SetBackgroundColor(Color(255, 7, 7))
    tip:SetText("WARNING: Not for human consumption.")
    
    tip:SetFont("DermaDefault")
    tip:SizeToContents()
end