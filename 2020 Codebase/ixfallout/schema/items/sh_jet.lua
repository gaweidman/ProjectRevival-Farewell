ITEM.name = "Jet"
ITEM.model = "models/mosi/fallout4/props/aid/jet.mdl"
ITEM.description = "itemJetDesc"
ITEM.price = 20
ITEM.category = "Medical"

ITEM.functions.Inhale = {
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()
		local int = character:GetAttribute("int", 0)
		local stm = character:GetAttribute("stm", 0)
		local endurance = character:GetAttribute("end", 0)
			
		client:EmitSound("ui/using_jet.wav")
		client:RestoreStamina(math.min(30 + int, 100))
		character:SetAttrib("stm", stm + 0.2)
		character:SetAttrib("end", endurance + 0.2)
	end
}