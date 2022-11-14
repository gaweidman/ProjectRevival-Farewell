local meta = FindMetaTable("Entity")
local CHAIR_CACHE = {}

function meta:IsReader()
	return self:GetClass() == "ix_reader"
end