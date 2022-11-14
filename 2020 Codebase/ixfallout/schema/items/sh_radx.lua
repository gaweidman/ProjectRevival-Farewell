ITEM.name = "Rad-X"
ITEM.model = "models/mosi/fallout4/props/aid/radx.mdl"
ITEM.description = "itemRadXDesc"
ITEM.price = 20
ITEM.category = "Medical"

ITEM.functions.Dose = {
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()
		local radiation = character:GetData("radiation", 0)
		local int = character:GetAttribute("int", 0)
		
		client:EmitSound("ui/eating_mentats.wav")
		character:SetAttrib("int", int + 0.2)
		
		for i = 1, 120 + int do
			timer.Simple( 1 + i, function()
				if client and character and client:Alive() then
					client:SetRadiation(math.Clamp(radiation - int, 0, 100))
				end
			end)
		end
		
		timer.Simple( 121, function()
			if client and character and client:Alive() then
				client:EmitSound("ui/addicteds.wav")
				client:NotifyLocalized("itemRadXEffectsEnded")
			end
		end)
	end
}