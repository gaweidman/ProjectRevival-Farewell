ITEM.name = "itemKey"
ITEM.description = "Ключ для двери под номером #" --A key for door #
ITEM.price = 250
ITEM.model = "models/props_combine/combine_lock01.mdl"
ITEM.category = "Альянс"
ITEM.factions = {FACTION_CP, FACTION_CITIZEN}
ITEM.classes = {CLASS_CWU}
ITEM.functions.Assign = {
	OnRun = function(item)
	local client = item.player
	local data = {}
		data.start = client:GetShootPos()
		data.endpos = data.start + client:GetAimVector() * 96
		data.filter = client

	local tr = util.TraceLine( data )
	
	if IsValid(tr.Entity) then item:SetData("KeyCode", tr.Entity:GetKeyCode()) end
	return false
	end,
	OnCanRun = function(item)
		return item.player:GetCharacter():GetClass() == CLASS_CWU
	end
}

function ITEM:GetDescription()
	local description = self.description..self:GetData("KeyCode", 0)

	return description
end