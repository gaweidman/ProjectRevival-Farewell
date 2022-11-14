netstream.Hook("PrintIDChip", function(client, data)
    local name = data[1]
    local org = data[2]
    local role = data[3]
    local printerID = data[4]

    local printer = nil
    
    for k, v in ipairs(ents.FindByClass("ix_idprinter")) do
        if (v:GetCreationID() == printerID and IsValid(v)) then
            printer = v
        end
    end

    local isbClearance = 0
    local techClearance = 0
    local controlClearance = 0
    local class = ""
    local rank = ""

    if (org == "Imperial Security Bureau") then
        isbClearance = 1
    elseif (org == "Navy" and role == "Crewman") then
        controlClearance = 1
    elseif (org == "Navy" and role == "Technician") then
        techClearance = 1
    end

    if (org == "Stormtrooper Corps") then
        class = CLASS_STORMTROOPER
    elseif (org == "Navy" and role == "Crewman") then
        class = CLASS_NAVYCREWMAN
    elseif (org == "Navy" and role == "Medic") then
        class = CLASS_NAVYMEDIC
    elseif (org == "Navy" and role == "Trooper") then
        class = CLASS_NAVYTROOPER
    elseif (org == "Navy" and role == "Pilot") then
        class = CLASS_PILOT
    elseif (org == "Navy" and role == "Gunner") then
        class = CLASS_NAVYGUNNER
    elseif (org == "Navy" and role == "Technician") then
        class = CLASS_NAVYTECH
    elseif (org == "Imperial Security Bureau" and role == "Officer") then
        class = CLASS_ISB
    elseif (org == "Imperial Security Bureau" and role == "Death Trooper") then
        class = CLASS_DEATHTROOPER
    end

    if (role == "Stormtrooper") then
        role = "394th Stormtrooper Legion"
    elseif (role == "Shock Trooper") then
        role = "73rd Shock Trooper Batallion"
    elseif (role == "Shadow Trooper") then
        role = "26th Shadow Ops Battalion"
    elseif (role == "Scout Trooper") then
        role = "26th Scout Division"
    elseif (role == "Range Trooper") then
        role = "26th Range Trooper Battalion"
    end

    if (org == "Stormtrooper Corps" or org == "Death Trooper") then
        rank = "Recruit"
    elseif (org == "Navy" and role == "Technician") then
        rank = "Technician Third Class"
    elseif (org == "Navy" and role == "Trooper") then
        rank = "Trooper Third Class"
    elseif (org == "Navy" and role == "Medic") then
        rank = "Medical Crewman Third Class"
    elseif (org == "Navy" and role == "Crewman") then
        rank = "Crewman Third Class"
    elseif (org == "Navy" and role == "Gunner") then
        rank = "Gunner Third Class"
    elseif (org == "Navy" and role == "Pilot") then
        rank = "Cadet"
    elseif (org == "Imperial Security Bureau") then
        rank = "Officer Cadet"
    end


    ix.item.Spawn("identichip", printer:GetPos() + Vector(0, 10, 0), function() end, Angle(0, 0, 0), {
        ["charName"] = name,
        ["org"] = org,
        ["role"] = role,
        ["rankName"] = rank,
        ["clearance"] = {
            ["control"] = 0,
            ["systems"] = 0,
            ["isb"] = 0
        },
        ["class"] = class 
    })
end)

netstream.Hook("UpdateID", function(client, data)
    local name = data[1]
    local org = data[2]
    local role = data[3]
    local managerID = data[5]
    local hasId = false

    local idItem

    local inv = client:GetCharacter():GetInventory()

    for k, v in pairs(inv:GetItemsByUniqueID("identichip", true)) do
        hasId = true
        idItem = v
    end

    print(hasId)
    if (!hasId) then
        return
    else
        local manager = nil

        
        
        for k, v in ipairs(ents.FindByClass("ix_idmanager")) do
            if (v:GetCreationID() == managerID and IsValid(v)) then
                manager = v
            end
        end

        

        local isbClearance = 0
        local techClearance = 0
        local controlClearance = 0
        local class = ""

        if (org == "Imperial Security Bureau") then
            isbClearance = 1
        elseif (org == "Navy" and role == "Crewman") then
            controlClearance = 1
        elseif (org == "Navy" and role == "Technician") then
            techClearance = 1
        end

        

        if (org == "Stormtrooper Corps") then
            class = CLASS_STORMTROOPER
        elseif (org == "Navy" and role == "Crewman") then
            class = CLASS_NAVYCREWMAN
        elseif (org == "Navy" and role == "Medic") then
            class = CLASS_NAVYMEDIC
        elseif (org == "Navy" and role == "Trooper") then
            class = CLASS_NAVYTROOPER
        elseif (org == "Navy" and role == "Pilot") then
            class = CLASS_PILOT
        elseif (org == "Navy" and role == "Gunner") then
            class = CLASS_NAVYGUNNER
        elseif (org == "Navy" and role == "Technician") then
            class = CLASS_NAVYTECH
        elseif (org == "Imperial Security Bureau" and role == "Officer") then
            class = CLASS_ISB
        elseif (org == "Imperial Security Bureau" and role == "Deathtrooper") then
            class = CLASS_DEATHTROOPER
        end

        if (role == "Stormtrooper") then
            role = "394th Stormtrooper Legion"
        elseif (role == "Shock Trooper") then
            role = "73rd Shock Trooper Batallion"
        elseif (role == "Shadow Trooper") then
            role = "26th Shadow Ops Battalion"
        elseif (role == "Scout Trooper") then
            role = "26th Scout Division"
        elseif (role == "Range Trooper") then
            role = "26th Range Trooper Battalion"
        end

        print(data[6])
        newData = {
            ["charName"] = name,
            ["org"] = org,
            ["role"] = role,
            ["rankName"] = data[6],
            ["clearance"] = {
                ["control"] = data[4]["control"],
                ["systems"] = data[4]["systems"],
                ["isb"] = data[4]["isb"]
            }
        }

        for k, v in pairs(newData) do 
            --print("["..k.."] `".. " " .. v)
            idItem:SetData(k, v)
        end
    end
end)