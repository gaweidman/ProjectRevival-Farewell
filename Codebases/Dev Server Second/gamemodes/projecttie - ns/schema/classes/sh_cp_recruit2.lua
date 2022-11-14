-- Set the 'nice' display name for the class.
CLASS.name = "Metrocop Recruit 2"
-- Set the faction that the class belongs to.
CLASS.faction = FACTION_SECRET

-- Set what happens when the player has been switched to this class.
-- It passes the player which just switched.
function CLASS:OnSet(client)
	client:SetModel("models/Barney.mdl")
end

-- CLASS.index is defined internall when the class is registered.
-- It is basically the class's numeric ID.
-- We set a global variable to save this index for easier reference.
CLASS_CP_RCT2 = CLASS.index