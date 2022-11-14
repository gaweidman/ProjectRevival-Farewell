ITEM.name = "Impact Grenade"
ITEM.description = "A strange, spherical-ish grenade that explodes on impact."
ITEM.model = "models/forrezzur/impactgrenade.mdl"
ITEM.class = "rw_sw_nade_impact"
ITEM.weaponCategory = "throwable"
ITEM.width = 1
ITEM.height = 1

ITEM.functions.Equip = {
	name = "Equip",
	tip = "equipTip",
	icon = "icon16/tick.png",
	OnRun = function(item)
		item:Equip(item.player)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player
        return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true and
		hook.Run("CanPlayerEquipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
            
	end
}