ITEM.name = "Blunt"
ITEM.description = "A UU-Brand cigarette roll with marijuana packed inside."
ITEM.model = Model("models/phycitnew.mdl")
ITEM.category = "Drugs"
ITEM.width = 1
ITEM.height = 1

ITEM.functions.Eat = {
	sound = "npc/barnacle/barnacle_gulp1.wav",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:GetCharacter():AddBoost("weedAgi", "agi", -1)
		client:GetCharacter():AddBoost("cocaineStm", "stm", -1)
		client:GetCharacter():AddBoost("cocaineMedical", "medical", 1)
		client:GetCharacter():AddBoost("cocaineEng", "eng", 1)
		client:GetCharacter():AddBoost("cocaineguns", "guns", 1)
		hook.Run("SetupDrugTimer", client, client:GetCharacter(), itemTable.uniqueID, 1800)
	end
}

ITEM.screenspaceEffects = function()
	DrawMotionBlur(0.25, 1, 0)
end