ITEM.name = "Identichip"
ITEM.model = "models/gibs/metal_gib4.mdl"
ITEM.description = "A metal tag with a holographic display for identification."
ITEM.category = "Miscellaneous"
ITEM.width = 1 -- Width and height refer to how many grid spaces this item takes up.
ITEM.height = 1

function ITEM:PopulateTooltip(tooltip)
    local clearanceTable = self:GetData("clearance", {
        ["control"] = 0,
        ["systems"] = 0,
        ["isb"] = 0
        
    })

    local orgData = self:GetData("org", "Undefined")
    local roleData = self:GetData("role", "Undefined")

    local classIndex = 1
    if (orgData == "Stormtrooper Corps") then
        classIndex = CLASS_STORMTROOPER
    elseif (roleData == "Death Trooper") then
        classIndex = CLASS_DEATHTROOPER
    elseif (roleData == "Imperial Security Bureau") then
        classIndex = CLASS_ISBOFFICER
    elseif (roleData == "Medical") then
        classIndex = CLASS_NAVYMEDIC
    elseif (roleData == "Technician") then
        classIndex = CLASS_NAVYTECH
    elseif (roleData == "Trooper") then
        classIndex = CLASS_NAVYTROOPER
    elseif (roleData == "Pilot") then
        classIndex = CLASS_PILOT
    elseif (roleData == "Crewman") then
        classIndex = CLASS_CREWMAN
    end

    local rankName = self:GetData("rankName", "UNDEFINED")

    local charName = tooltip:AddRow("charName")
    charName:SetText("Name: "..self:GetData("charName", "Undefined"))

    local org = tooltip:AddRow("org")
    org:SetText("Organization: "..self:GetData("org", "Undefined"))

    local role = tooltip:AddRow("role")
    if (orgData == "Stormtrooper Corps") then
        role:SetText("Regiment: "..roleData)
    else
        role:SetText("Role: "..roleData)
    end

    local rank = tooltip:AddRow("rank")
    rank:SetText("Rank: "..rankName)

    
    local clearance = tooltip:AddRow("clearance")
    
    clearance:SetText(
        "Clearance:".."\n"..
        "    Control: "..clearanceTable["control"].."\n"..
        "    Systems: "..clearanceTable["systems"].."\n"..
        "    ISB: "..clearanceTable["isb"]
    )
    
    clearance:SizeToContents()

    /*
    local control = tooltip:AddRow("control")
    control:SetText("\tControl: "..clearanceTable["control"])

    clearance:SetText("test")
    */
    

    tooltip:SizeToContents()

end