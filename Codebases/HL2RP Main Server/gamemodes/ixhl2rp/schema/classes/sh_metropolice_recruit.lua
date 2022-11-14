CLASS.name = "Metropolice Recruit"
CLASS.faction = FACTION_MPF
CLASS.isDefault = true

function CLASS:CanSwitchTo(client)
	return Schema:HasBiosignalRank(client:Name(), "RCT")
end

CLASS_MPR = CLASS.index