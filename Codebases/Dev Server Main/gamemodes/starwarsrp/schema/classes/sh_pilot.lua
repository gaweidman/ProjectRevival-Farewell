
CLASS.name = "Pilot"
CLASS.faction = FACTION_NAVY
CLASS.Ranks = {
    [1] = {"Cadet", nil, nil},
    [2] = {"Flight Crewman Third Class", nil, nil},
    [3] = {"Flight Crewman Second Class", nil, nil},
    [4] = {"Flight Crewman First Class", nil, nil},
    [5] = {"Flight Petty Officer Third Class", nil, nil},
    [6] = {"Flight Petty Officer Second Class", nil, nil},
    [7] = {"Flight Petty Officer First Class", nil, nil},
    [8] = {"Chief Petty Officer", nil, nil},
    [9] = {"Flight Midshipman", nil, nil},
    [10] = {"Flight Junior Lieutenant", nil, nil},
    [11] = {"Flight Lieutenant", nil, nil},
    [12] = {"Flight Senior Lieutenant", nil, nil},
    [13] = {"Captain", nil, nil},
    [14] = {"Lieutenant Commander", nil, nil}
}

-- This function will be called whenever the client wishes to become part of this class. If you'd rather have it so this class
-- has to be set manually by an administrator, you can simply return false to disallow regular users switching to this class.
-- Note that CLASS.isDefault does not add a whitelist like FACTION.isDefault does, which is why we need to use CLASS:OnCanBe.
function CLASS:CanSwitchTo(client)
	return false
end

CLASs_PILOT = CLASS.index 