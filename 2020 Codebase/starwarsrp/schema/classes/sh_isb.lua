
CLASS.name = "Internal Security Bureau"
CLASS.faction = FACTION_ISB
CLASS.Ranks = {
    [1] = {"Officer Cadet", nil, nil},
    [2] = {"Agent", nil, nil},
    [3] = {"Senior Agent", nil, nil},
    [4] = {"Sub-Lieutenant", nil, nil},
    [5] = {"Lieutenant", nil, nil},
    [6] = {"Captain", nil, nil},
    [7] = {"Brigadier", nil, nil},
    [8] = {"Inspector General", nil, nil},
    [9] = {"Deputy Director", nil, nil},
    [10] = {"Director", nil, nil}
}

-- This function will be called whenever the client wishes to become part of this class. If you'd rather have it so this class
-- has to be set manually by an administrator, you can simply return false to disallow regular users switching to this class.
-- Note that CLASS.isDefault does not add a whitelist like FACTION.isDefault does, which is why we need to use CLASS:OnCanBe.
function CLASS:CanSwitchTo(client)
	return false
end
CLASS_ISB = CLASS.index