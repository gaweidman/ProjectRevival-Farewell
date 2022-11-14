MODE_SWIPE_CARD = {
    ["enum"] = 1, 
    ["msg"] = "Insert\nIdentichip", 
    ["color"] = Color(255, 255, 255)
}

MODE_ACCESS_GRANTED = {
    ["enum"] = 2, 
    ["msg"] = "Access\nGranted", 
    ["color"] = Color(40, 255, 40)
}

MODE_ACCESS_DENIED = {
    ["enum"] = 3, 
    ["msg"] = "Access\nDenied", 
    ["color"] = Color(255, 40, 40)
}

MODE_OPEN = {
    ["enum"] = 4, 
    ["msg"] = "Open", 
    ["color"] = Color(40, 255, 40)
}

MODE_LOCKDOWN = {
    ["enum"] = 5, 
    ["msg"] = "Locked\nDown", 
    ["color"] = Color(255, 40, 40)
}

MODE_UNDEFINED = {
    ["enum"] = 6, 
    ["msg"] = "UNDEFINED", 
    ["color"] = Color(255, 40, 255)
}

function PLUGIN:SaveReaders()
    local readers = {}

    for k, v in ipairs(ents.FindByClass("ix_reader")) do
        if (IsValid(v)) then

            readers[#readers + 1] = {
                v:GetPos(),
                v:GetAngles(),
                v:GetNetVar("linkedDoors", {}),
                v:GetNetVar("mode", MODE_UNDEFINED),
                v:GetNetVar("reqClr", {})
            }

            if (v:GetNetVar("mode", MODE_UNDEFINED).enum == MODE_ACCESS_DENIED.enum or v:GetNetVar("mode", MODE_UNDEFINED).enum == MODE_ACCESS_GRANTED.enum) then
                v[4] = MODE_SWIPE_CARD
            end
        end
    end

    ix.data.Set("readers", readers)
end

function PLUGIN:LoadReaders()
    local readers = ix.data.Get("readers", {})

    for k, v in ipairs(readers) do
        local readerEnt = ents.Create("ix_reader")
        
        readerEnt:SetPos(v[1])
        readerEnt:SetAngles(v[2])
        readerEnt:SetNetVar("linkedDoors", v[3])
        readerEnt:SetNetVar("mode", v[4])
        readerEnt:SetNetVar("reqClr", v[5])

        if (v[4].enum == MODE_SWIPE_CARD.enum or v[4].enum == MODE_LOCKDOWN.enum) then
            for k2, v2 in ipairs(ents.GetAll()) do
                for k3, v3 in pairs(v[3]) do
                    if (v2:MapCreationID() == v3) then
                        v2:Fire("Lock")
                    end
                end
            end
        end

        readerEnt:Spawn()
        readerEnt:GetPhysicsObject():EnableMotion(false) -- Doesn't do an IsValid check for simplicity reasons. If something is broken, add an IsValid check.
    end
end

function PLUGIN:SaveData()
    self:SaveReaders()
end

function PLUGIN:LoadData()
    self:LoadReaders()
end
