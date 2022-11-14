-- Set the 'nice' display name for the class.
CLASS.name = "Stormtrooper"
-- Set the faction that the class belongs to.
CLASS.faction = FACTION_TK

-- Set what happens when the player has been switched to this class.
-- It passes the player which just switched.
function CLASS:OnSet(client)
	client:SetModel("models/player/swbf_imperial_officer_ncov2/swbf_imperial_officer_ncov2.mdl")
end

-- CLASS.index is defined internall when the class is registered.
-- It is basically the class's numeric ID.
-- We set a global variable to save this index for easier reference.
CLASS_TK_TS = CLASS.index

if (SERVER) then
	-- Hook the 'charname' variable to change the class of a playing if the character's name
	-- contains 'TC/' inside.
	nut.char.HookVar("charname", "recruitRanks", function(character)
		local client = character.player

		if (IsValid(client) and client:Team() == FACTION_CP and string.find(character:GetVar("charname"), "TC/")) then
			client:SetCharClass(CLASS_TK_TC)
		end
	end)
end
