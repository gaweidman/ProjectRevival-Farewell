local ITEM = ix.meta.item or {}
ITEM.__index = ITEM
ITEM.name = "Undefined"
ITEM.description = ITEM.description or "An item that is undefined."
ITEM.id = ITEM.id or 0
ITEM.uniqueID = "undefined"

function ITEM:GetBase()
    return self.base or nil
end