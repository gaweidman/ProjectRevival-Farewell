
ITEM.name = "Sunset Sarsaparilla star bottle cap"
ITEM.model = "models/fallout/clutter/junk/ssbottlecap01.mdl"
ITEM.description = "itemBottlecapStarDesc"
ITEM.price = 1

ITEM.functions.Use = {
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()

		character:GiveMoney(1)
		client:NotifyLocalized("bottlecapAquired")
	end
}