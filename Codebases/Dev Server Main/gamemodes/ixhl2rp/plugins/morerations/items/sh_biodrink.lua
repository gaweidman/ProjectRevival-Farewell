
ITEM.name = "Biotic Grade Beverage"
ITEM.model = Model("models/props_cunk/popcan01a.mdl")
ITEM.skin = 2
ITEM.description = "A green liquid that would taste like poison to humans."
ITEM.category = "Consumables"

ITEM.functions.Drink = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local character = client:GetCharacter()
		local thirst = character:GetData("thirst", 100)

		if (ix.faction.Get(client:Team()).name == "Vortigaunt") then
			client:SetThirst(math.Clamp(thirst + 100, 0, 100))
			client:EmitSound("npc/antlion_grub/squashed.wav", 75, 150, 0.25)
		else
			client:SetHealth(math.Clamp(client:Health() - 10, 0, client:GetMaxHealth()))
			if (client:Health() <= 0) then
				client:Kill()
			end
		end

		client:EmitSound("npc/barnacle/barnacle_gulp2.wav", 75, 90, 0.35)
	end,
	OnCanRun = function(itemTable)
		return true
	end
}

function ITEM:PopulateTooltip(tooltip)
	local tip = tooltip:AddRow("warning")
    tip:SetBackgroundColor(Color(255, 7, 7))
    tip:SetText("WARNING: Not for human consumption.")
    
    tip:SetFont("DermaDefault")
    tip:SizeToContents()
end
