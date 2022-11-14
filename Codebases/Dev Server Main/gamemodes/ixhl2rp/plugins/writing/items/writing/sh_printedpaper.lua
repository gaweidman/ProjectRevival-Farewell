local PLUGIN = PLUGIN

ITEM.name = "Printed Paper"
ITEM.description = "A piece of paper in good condition."
ITEM.price = 0
ITEM.model = Model("models/props_c17/paper01.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.bAllowMultiCharacterInteraction = true

function ITEM:SetText(text, character, setOwner)
	text = tostring(text):sub(1, PLUGIN.maxLength)

	self:SetData("text", text, false, false, true)

	if (setOwner) then
		self:SetData("owner", character and character:GetID() or 0)
	end
end

function ITEM:SetPickupable(pickupable)
	self:SetData("pickupable", pickupable)
end

function ITEM:SetEditable(editable)
	self:SetData("editable", editable)
end

ITEM.functions.View = {
	OnRun = function(item)
		-- itemID, text, pickupOthers, editableOthers, editing, handwritten
		netstream.Start(item.player, "ixViewPaper", item:GetID(), item:GetData("text", ""), item:GetData("pickupable", false), item:GetData("editable", false), false, true)
		return false
	end,

	OnCanRun = function(item)
		local owner = item:GetData("owner", 0)

		return not (owner == 0) 
	end
}

ITEM.functions.take.OnCanRun = function(item)
	local owner = item:GetData("owner", 0)
	return IsValid(item.entity) and (owner == 0 or owner == item.player:GetCharacter():GetID() or item:GetData("pickupable", false))
end