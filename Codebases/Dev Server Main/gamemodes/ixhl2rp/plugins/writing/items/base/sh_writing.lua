
ITEM.name = "Writing Base"
ITEM.model = Model("models/props_c17/paper01.mdl")
ITEM.description = "Something that can be written on."

function ITEM:OnEntityTakeDamage(self, damageInfo)
    return false
end
