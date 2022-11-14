local PLUGIN = PLUGIN

ITEM.name = "Notepad"
ITEM.description = "A piece of paper in good condition."
ITEM.price = 2
ITEM.model = Model("models/props_lab/clipboard.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.bAllowMultiCharacterInteraction = true

function ITEM:GetDescription()
	return self:GetData("owner", 0) == 0
		and string.format(self.description, "it's perfectly new.")
		or string.format(self.description, "it has been written on.")
end

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

ITEM.functions.Edit = {
	OnRun = function(item)
		netstream.Start(item.player, "ixViewPaper", item:GetID(), item:GetData("text", ""), item:GetData("pickupable", false), item:GetData("editable", false), true, true)
		return false
	end,

	OnCanRun = function(item)
		local owner = item:GetData("owner", 0)

		return owner == 0 or owner == item.player:GetCharacter():GetID() or item:GetData("editable", false)
	end
}-- itemID, text, pickupOthers, editableOthers, editing, handwritten

ITEM.functions.take.OnCanRun = function(item)
	local owner = item:GetData("owner", 0)
	return IsValid(item.entity) and (owner == 0 or owner == item.player:GetCharacter():GetID() or item:GetData("pickupable", false))
end