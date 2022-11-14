
CLASS.name = "Navy Medical Crewman"
CLASS.faction = FACTION_NAVY
CLASS.Ranks = {
    [1] = {"Medical Crewman Third Class", nil, nil},
    [2] = {"Medical Crewman Second Class", nil, nil},
    [3] = {"Medical Crewman First Class", nil, nil},
    [4] = {"Petty Officer Third Class", nil, nil},
    [5] = {"Petty Officer Second Class", nil, nil},
    [6] = {"Petty Officer First Class", nil, nil},
    [7] = {"Chief Petty Officer", nil, nil},
    [8] = {"Ensign", nil, nil},
    [9] = {"Lieutenant", nil, nil},
    [10] = {"Lieutenant Commander", nil, nil},
    [11] = {"Captain", nil, nil},
    [12] = {"Commodore", nil, nil},
    [13] = {"Rear Admiral", nil, nil},
    [14] = {"Vice Admiral", nil, nil},
    [15] = {"Admiral", nil, nil},
    [15] = {"Grand Admiral", nil, nil}
}

-- This function will be called whenever the client wishes to become part of this class. If you'd rather have it so this class
-- has to be set manually by an administrator, you can simply return false to disallow regular users switching to this class.
-- Note that CLASS.isDefault does not add a whitelist like FACTION.isDefault does, which is why we need to use CLASS:OnCanBe.
function CLASS:CanSwitchTo(client)
	return false
end

CLASS_MEDICALNAVYCREWMAN = CLASS.index