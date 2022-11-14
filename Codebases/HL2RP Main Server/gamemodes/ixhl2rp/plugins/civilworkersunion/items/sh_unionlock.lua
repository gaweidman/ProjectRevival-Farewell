ITEM.name = "Union Lock"
ITEM.description = "A metal apparatus applied to doors, openable with a CWU ID."  --A metal apparatus applied to doors.
ITEM.price = 250
ITEM.model = "models/props_combine/combine_lock01.mdl"
ITEM.category = "Альянс"
ITEM.factions = {FACTION_CP}
ITEM.functions.Place = {
	OnRun = function(item)
		local data = {}
		data.start = item.player:GetShootPos()
		data.endpos = data.start + item.player:GetAimVector()*128
		data.filter = item.player

		local trace = client:GetEyeTrace()

		if IsValid(trace.Entity) and trace.Entity:GetClass() == "ix_container" and !trace.Entity:IsLocked() and !trace.Entity:GetCWULocked() and !trace.Entity:GetCombineLocked() then
			trace.Entity:SetCWULocked(true)
			trace.Entity:SetCWURet(true)
			client:EmitSound("physics/metal/weapon_impact_soft2.wav", 75, 80)
			return true
		end
		
		if (IsValid(scripted_ents.Get("ix_unionlock"):SpawnFunction(item.player, util.TraceLine(data)))) then
			item.player:EmitSound("npc/roller/mine/rmine_blades_out3.wav", 100, 90)
		else
			return false
		end
	end
}