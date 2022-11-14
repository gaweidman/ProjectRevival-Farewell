ITEM.name = "Cocaine"
ITEM.description = "A dime bag of a white powder. Wonder what it smells like."
ITEM.model = Model("models/props_junk/garbage_bag001a.mdl")
ITEM.category = "Drugs"
ITEM.width = 1
ITEM.height = 1

ITEM.functions.Sniff = {
	sound = "npc/barnacle/barnacle_gulp1.wav",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:GetCharacter():AddBoost("cocaineAgi", "agi", 2)
		client:GetCharacter():AddBoost("cocaineStm", "stm", 2)
		client:GetCharacter():AddBoost("cocaineMedical", "medical", -2)
		client:GetCharacter():AddBoost("cocaineEng", "eng", -2)
		client:GetCharacter():AddBoost("cocaineguns", "guns", -2)

		hook.Run("SetupDrugTimer", client, client:GetCharacter(), itemTable.uniqueID, 1800)
	end
}

ITEM.screenspaceEffects = function()
	
end