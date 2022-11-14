ITEM.name = "Med-X"
ITEM.model = "models/mosi/fallout4/props/aid/medx.mdl"
ITEM.description = "itemMedXDesc"
ITEM.price = 20
ITEM.category = "Medical"

ITEM.functions.Dose = {
	OnRun = function(item)
		local client = item.player
		local armor = client:Armor()
		local character = client:GetCharacter()
		local intelligence = character:GetAttribute("int", 0)
		local endurance = character:GetAttribute("end", 0)
		
		client:EmitSound("ui/stim.wav")
		character:SetAttrib("end", endurance + 0.2)
		
		if armor > 15 then
			client:SetArmor(math.Clamp(armor, 0, 225))
		else
			client:SetArmor(math.Clamp(15 + intelligence, 0, 225))
		end
		
		for i = 5, 40 do
			timer.Simple( 1 + i, function()
				if client and character and client:Alive() then
					if armor > 15 then
						client:SetArmor(math.Clamp(armor, 0, 225))
					else
						client:SetArmor(math.Clamp(15 + intelligence, 0, 225))
					end
				end
			end)
		end
		
		timer.Simple( 41, function()
			if client and character and client:Alive() then
				client:SetArmor(armor)
				character:SetAttrib("end", endurance)
				client:EmitSound("ui/addicteds.wav")
				client:NotifyLocalized("itemMedXEffectsEnded")
			end
		end)
	end
}