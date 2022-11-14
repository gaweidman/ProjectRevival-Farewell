ITEM.name = "Alcohol"
ITEM.description = "Simple."
ITEM.category = "Alcohol"
ITEM.model = "models/props_lab/bindergraylabel01b.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.force = 0
ITEM.thirst = 0
ITEM.radiation = 0
ITEM.empty = false

ITEM.functions.Drink = {
	icon = "icon16/drink.png",
	OnRun = function(item)
		local client = item.player
		local char = client:GetCharacter()
		local thirst = char:GetData("thirst", 100)
		local radiation = char:GetData("radiation", 0)
		local str = char:GetAttribute("str", 0)
		local int = char:GetAttribute("int", 0)
		
		if thirst and item.thirst then
			client:SetThirst(math.Clamp(thirst + item.thirst, 0, 100))
		end

		if radiation and item.radiation then
			client:SetRadiation(math.Clamp(radiation + item.radiation, 0, 100))
		end
		
		char:SetData("drunk", char:GetData("drunk") + item.force)
		client:EmitSound( "npc/barnacle/barnacle_gulp2.wav" )
		hook.Run("Drunk", client)
		
		if item.empty then
			local inv = char:GetInventory()
			inv:Add(item.empty)
		end

		if str then
			char:SetAttrib("str", math.max(0, str + 1))

			timer.Simple(120, function()
				str = char:GetAttribute("str", 0)

				client:GetCharacter():SetAttrib("str", math.max(0, str - 1))
			end)
		end

		if int then
			char:SetAttrib("int", math.max(0, int - 1))

			timer.Simple(120, function()
				int = char:GetAttribute("int", 0)

				client:GetCharacter():SetAttrib("int", math.max(0, int + 1))
			end)
		end
	end
}