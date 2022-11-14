ITEM.name = "Cyclopic Citizen Suit"
ITEM.description = "A baggy suit with an apron and a single lens to look through."
ITEM.category = "Outfit"
ITEM.model = "models/props_c17/BriefCase001a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.outfitCategory = "model"
ITEM.isGasMask = true
ITEM.pacData = {}

function ITEM:PopulateTooltip(tooltip)
	local durabilityRow = tooltip:AddRow("filterDurability")
	local color = Color(75, 75, 75)
	local durability = self:GetData("filterDurability", 0)
	local maxDurability = self:GetData("maxFilterDurability", 0)
	
	if durability / maxDurability >= 0.8 then
		color = Color(25, 186, 0)
	elseif durability / maxDurability >= 0.6 then
		color = Color(155, 194, 0)
	elseif durability / maxDurability >= 0.4 then
		color = Color(194, 191, 0)
	elseif durability / maxDurability >= 0.2 then
		color = Color(194, 123, 0)
	else
		color = Color(194, 0, 0)
	end

    durabilityRow:SetBackgroundColor(color)
	durabilityRow:SetText("Time Left: "..durability.." minutes.")
    durabilityRow:SetFont("DermaDefault")
    durabilityRow:SizeToContents()
end

function ITEM:OnEquipped()
	self:GetOwner():GetCharacter():SetData("gasmask", self.uniqueID)
end

function ITEM:OnUnequipped()
	self:GetOwner():GetCharacter():SetData("gasmask", false)
end

ITEM.replacements = "models/industrial_uniforms/pm_industrial_uniform.mdl"

--[[
-- This will change a player's skin after changing the model. Keep in mind it starts at 0.
ITEM.newSkin = 1
-- This will change a certain part of the model.
ITEM.replacements = {"group01", "group02"}
-- This will change the player's model completely.
ITEM.replacements = "models/manhack.mdl"
-- This will have multiple replacements.
ITEM.replacements = {
	{"male", "female"},
	{"group01", "group02"}
}

-- This will apply body groups.
ITEM.bodyGroups = {
	["blade"] = 1,
	["bladeblur"] = 1
}
]]--