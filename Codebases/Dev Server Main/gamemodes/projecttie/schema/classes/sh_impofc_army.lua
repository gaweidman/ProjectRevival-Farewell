-- Set the 'nice' display name for the class.
CLASS.name = "Imperial Army Officer"
-- Set the faction that the class belongs to.
CLASS.faction = FACTION_IMPOFC

-- Set what happens when the player has been switched to this class.
-- It passes the player which just switched.
function CLASS:OnSet(client)
	client:SetModel("models/player/swbf_imperial_officer_ensignv2/swbf_imperial_officer_ensignv2.mdl")
end

-- CLASS.index is defined internall when the class is registered.
-- It is basically the class's numeric ID.
-- We set a global variable to save this index for easier reference.
CLASS_IMPOFC_NAVY = CLASS.index