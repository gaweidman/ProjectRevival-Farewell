PLUGIN.name = "Civil Workers' Union"
PLUGIN.author = "LiGyH, CombineFodder, DrodA"
PLUGIN.description = "Adds Union locks to doors."

ix.util.Include("sv_hooks.lua")

ix.lang.AddTable("russian", {
 	itemKey = "Ключ",
 	itemUnionLock = "Замок ГСР"
})

ix.lang.AddTable("english", {
 	itemKey = "Key",
 	itemUnionLock = "Union Lock"
})

if (SERVER) then
	function PLUGIN:SaveUnionLocks()
	local data = {}
		for _, v in ipairs(ents.FindByClass("ix_unionlock")) do
			if (IsValid(v.door)) then
				data[#data + 1] = {
					v.door:MapCreationID(),
					v.door:WorldToLocal(v:GetPos()),
					v.door:WorldToLocalAngles(v:GetAngles()),
					v:GetLocked(),
					v:GetKeyCode()
				}
			end
		end
		ix.data.Set("unionLocks", data)
	end

	function PLUGIN:LoadUnionLocks()
		for _, v in ipairs(ix.data.Get("unionLocks") or {}) do
			local door = ents.GetMapCreatedEntity(v[1])

			if (IsValid(door) and door:IsDoor()) then
				local lock = ents.Create("ix_unionlock")

				lock:SetPos(door:GetPos())
				lock:Spawn()
				lock:SetDoor(door, door:LocalToWorld(v[2]), door:LocalToWorldAngles(v[3]))
				lock:SetLocked(v[4])
				lock:SetKeyCode(v[5])
			end
		end
	end
end


