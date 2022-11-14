
ITEM.name = "Skill Book"
ITEM.description = "A skill book."
ITEM.category = "Books"
ITEM.model = "models/weapons/w_pistol.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 100
ITEM.skill = "strength"
ITEM.skillAmount = 1

ITEM.functions.Read = {
	icon = "icon16/book_open.png",
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()
		local skill = skill
		local att = character:GetAttribute(skill, 0)
		
		if item.skill == "strength" then
			local skill = "str"
		elseif item.skill == "endurance" then
			local skill = "end"
		elseif item.skill == "intelligence" then
			local skill = "int"
		elseif item.skill == "agility" then
			local skill = "stm"
		elseif item.skill == "luck" then
			local skill = "lck"
		end

		character:SetAttrib(skill, math.max(att + item.skillAmount, 0))
	end
}
