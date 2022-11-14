
PLUGIN.name = "Flashlight item"
PLUGIN.author = "SleepyMode"
PLUGIN.description = "Adds an item allowing players to toggle their flashlight."

function PLUGIN:PlayerSwitchFlashlight(client, bEnabled)
	local character = client:GetCharacter()
	local inventory = character and character:GetInventory()

	if !inventory then return end

	local suitLight = inventory:HasItem("workeroutfit", {equip = true}) or inventory:HasItem("supervisoroutfit", {equip = true})
	if suitLight then
		if bEnabled then
			client:SetSkin(0)
		else
			client:SetSkin(1)
		end
		return true
	elseif inventory:HasItem("flashlight") then
		return true
	end
end