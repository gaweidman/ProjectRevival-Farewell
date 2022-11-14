PLUGIN.name = "Flashlight"
PLUGIN.author = "Chessnut, Frosty"
PLUGIN.description = "Provides a flashlight item to regular flashlight usage."

ix.lang.AddTable("english", {
	itemFlashlightDesc = "A handheld flashlight batteries included.",
})
ix.lang.AddTable("korean", {
	["Flashlight"] = "손전등",
	itemFlashlightDesc = "전지가 들어있는 평범한 손전등입니다.",
})

function PLUGIN:PlayerSwitchFlashlight(client, state)
	local character = client:GetCharacter()

	if (!character or !character:GetInventory()) then
		return false
	end

	if (character:GetInventory():HasItem("flashlight")) then
		return true
	end
end