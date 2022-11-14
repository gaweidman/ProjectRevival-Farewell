ITEM.name = "Food base"
ITEM.description = "A food."
ITEM.model = "models/props_lab/bindergraylabel01b.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Food"
ITEM.hunger = 0
ITEM.thirst = 0
ITEM.radiation = 0
ITEM.empty = false
ITEM.functions.Eat = {
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()
		local hunger = character:GetData("hunger", 100)
		local thirst = character:GetData("thirst", 100)
		local radiation = character:GetData("radiation", 0)
		
		if hunger then
			if item.hunger then
				client:SetHunger(math.Clamp(hunger + item.hunger, 0, 100))
			end
		end

		if thirst then
			if item.thirst then
				client:SetThirst(math.Clamp(thirst + item.thirst, 0, 100))
			end
		end

		if radiation then
			if item.radiation then
				client:SetRadiation(math.Clamp(radiation + item.radiation, 0, 100))
			end
		end
		
		if item.empty then
			local inv = character:GetInventory()

			inv:Add(item.empty)
		end
	end,
	icon = "icon16/cup.png"
}