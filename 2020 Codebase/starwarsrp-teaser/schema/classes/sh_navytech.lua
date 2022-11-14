
CLASS.name = "Navy Technician"
CLASS.faction = FACTION_NAVY
CLASS.Ranks = {
    [1] = {"Cadet", nil, nil},
    [2] = {"Technician Third Class", nil, nil},
    [3] = {"Technician Second Class", nil, nil},
    [4] = {"Technician First Class", nil, nil},
    [5] = {"Petty Officer Third Class", nil, nil},
    [6] = {"Petty Officer Second Class", nil, nil},
    [7] = {"Petty Officer First Class", nil, nil},
    [8] = {"Chief Petty Officer", nil, nil},
    [9] = {"Ensign", nil, nil},
    [10] = {"Lieutenant", nil, nil},
    [11] = {"Lieutenant Commander", nil, nil},
    [12] = {"Captain", nil, nil},
    [13] = {"Commodore", nil, nil},
    [14] = {"Rear Admiral", nil, nil},
    [15] = {"Vice Admiral", nil, nil},
    [16] = {"Admiral", nil, nil},
    [17] = {"Grand Admiral", nil, nil}
}

-- This function will be called whenever the client wishes to become part of this class. If you'd rather have it so this class
-- has to be set manually by an administrator, you can simply return false to disallow regular users switching to this class.
-- Note that CLASS.isDefault does not add a whitelist like FACTION.isDefault does, which is why we need to use CLASS:OnCanBe.
function CLASS:CanSwitchTo(client)
	return false
end

CLASs_NAVYTECH = CLASS.index