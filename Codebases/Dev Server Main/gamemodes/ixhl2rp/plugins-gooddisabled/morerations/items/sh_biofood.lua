ITEM.name = "Biotic Grade Food"
ITEM.model = Model("models/pg_plops/pg_food/pg_tortellinas.mdl")
ITEM.description = "A green and white box filled with dead bugs."

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local character = client:GetCharacter()
		local hunger = character:GetData("hunger", 100)
		
		if (ix.faction.Get(client:Team()).name == "Vortigaunt") then
			client:SetHunger(math.Clamp(hunger + 100, 0, 100))
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
