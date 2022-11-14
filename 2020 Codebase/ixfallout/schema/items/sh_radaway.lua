ITEM.name = "Radaway"
ITEM.model = "models/mosi/fallout4/props/aid/radaway.mdl"
ITEM.description = "itemRadawayDesc"
ITEM.price = 20
ITEM.category = "Medical"

ITEM.functions.Inject = {
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()
		local radiation = character:GetData("radiation", 0)
		
		if character:GetAttribute("int", 0) then
			local int = character:GetAttribute("int", 0)
			local intMult = ix.config.Get("intelligenceMultiplier", 1)
			
			client:EmitSound("ui/using_jet.wav")
			client:SetRadiation(math.max(radiation - 50 - int * intMult, 0))
		else
			client:EmitSound("ui/using_jet.wav")
			client:SetRadiation(math.max(radiation - 50 - int * intMult, 0))
		end
	end
}