
CLASS.name = "Deathtrooper"
CLASS.faction = FACTION_ISB
CLASS.Ranks = {
    [1] = {"Recruit", nil, nil},
    [2] = {"Private", nil, nil},
    [3] = {"Private First Class", nil, nil},
    [4] = {"Lance Corporal", nil, nil},
    [5] = {"Corporal", nil, nil},
    [6] = {"Sergeant", nil, nil},
    [7] = {"Staff Sergeant", nil, nil},
    [8] = {"Gunnery Sergeant", nil, nil},
    [9] = {"Master Sergeant", nil, nil},
    [10] = {"First Sergeant", nil, nil},
    [11] = {"Sergeant Major", nil, nil},
    [12] = {"Second Lieutenant", nil, nil},
    [13] = {"First Lieutenant", nil, nil},
    [14] = {"Captain", nil, nil},
    [15] = {"Lieutenant Colonel", nil, nil},
    [14] = {"Colonel", nil, nil},
    [15] = {"Commander", nil, nil}
}


function CLASS:CanSwitchTo(client)
	return false
end

CLASS_DEATHTROOPER = CLASS.index