local PLUGIN = PLUGIN

PLUGIN.name = "Citizen Apartments"
PLUGIN.author = "QIncarnate"
PLUGIN.description = "A plugin to give citizens permanent apartments and door ownership."

ix.command.Add("AddTenant", {
    description = "Adds a tenant to a door.",
    arguments = ix.type.character,
    OnRun = function(self, client, character)
        local ent = client:GetEyeTrace().Entity

        if !client:GetCharacter():HasBiosignal() then
            return "You are not a member of the Combine!"
        end

        if ent == nil or ent:GetClass() != "prop_door_rotating" then
            return  "That is not a valid door!"
        end

        if (SERVER) then
            if (table.KeyFromValue(ent.tenantTbl["id"], character:GetID()) == nil) then
                ent.tenantTbl["id"][#ent.tenantTbl["id"] + 1] = character:GetID()
                ent.tenantTbl["name"][#ent.tenantTbl["name"] + 1] = character:GetName()

                local tenantsString = "This apartment belongs to "
                if (#ent.tenantTbl["name"] == 0) then
                    ent:SetNetVar("description", "")
                elseif (#ent.tenantTbl["name"] == 1) then
                    tenantsString = "This apartment belongs to "..ent.tenantTbl["name"][1].."."
                    ent:SetNetVar("description", tenantsString)
                elseif (#ent.tenantTbl["name"] == 2) then
                    tenantsString = "This apartment belongs to "..ent.tenantTbl["name"][1].." and "..ent.tenantTbl["name"][2].."."
                    ent:SetNetVar("description", tenantsString)
                elseif (#ent.tenantTbl["name"] >= 3) then
                    for k, v in ipairs(ent.tenantTbl["name"]) do
                        if (k == #ent.tenantTbl["name"]) then
                            tenantsString = tenantsString.."and "..v.."."
                            ent:SetNetVar("description", tenantsString)
                        else
                            tenantsString = tenantsString..v..", "
                            ent:SetNetVar("description", tenantsString)
                        end
                    end
                end
                
            else
                return "That person is already a tenant here!"
            end

        end

        return "Successfully added tenant."

    end
})

ix.command.Add("RemoveTenant", {
    description = "Removes the [x] listed tenant from a door.",
    arguments = ix.type.number,
    OnRun = function(self, client, tenantIndex)
        local ent = client:GetEyeTrace().Entity

        if !client:GetCharacter():HasBiosignal() then
            return "You are not a member of the Combine!"
        end

        if ent == nil or ent:GetClass() != "prop_door_rotating" then
            return "That is not a valid door!"
        end

        print(ent.tenantTbl["name"][tenantIndex])

        if (SERVER) then
            if (ent.tenantTbl["id"][tenantIndex] != nil) then
                table.remove(ent.tenantTbl["id"], tenantIndex)
                table.remove(ent.tenantTbl["name"], tenantIndex)

                local tenantsString = "This apartment belongs to "
                if (#ent.tenantTbl["name"] == 0) then
                    ent:SetNetVar("description", "")
                elseif (#ent.tenantTbl["name"] == 1) then
                    tenantsString = "This apartment belongs to "..ent.tenantTbl["name"][1].."."
                    ent:SetNetVar("description", tenantsString)
                elseif (#ent.tenantTbl["name"] == 2) then
                    tenantsString = "This apartment belongs to "..ent.tenantTbl["name"][1].." and "..ent.tenantTbl["name"][2].."."
                    ent:SetNetVar("description", tenantsString)
                elseif (#ent.tenantTbl["name"] >= 3) then
                    for k, v in ipairs(ent.tenantTbl["name"]) do
                        if (k == #ent.tenantTbl["name"]) then
                            tenantsString = tenantsString.."and "..v.."."
                        else
                            tenantsString = tenantsString..v..", "
                        end
                    end
                end
                
            else
                return "That is not a valid tenant!"
            end
        end
    end
})


if (SERVER) then

    function PLUGIN:LoadTenantData()
        local data = self:GetData()

        for k, v in ipairs(ents.GetAll()) do
            if (v:GetClass() == "prop_door_rotating" and v:MapCreationID() != -1) then
                if (data[v:MapCreationID()] != nil) then
                    v.tenantTbl = data[v:MapCreationID()]
                    if v.tenantTbl.name == nil then v.tenantTbl.name = {} end
                    if v.tenantTbl.id == nil then v.tenantTbl.id = {} end
                else
                    v.tenantTbl = {
                        ["id"] = {},
                        ["name"] = {}
                    }
                end
            end
        end

        for _, ent in ipairs(ents.GetAll()) do
            if (ent:GetClass() == "prop_door_rotating" and ent:MapCreationID() != -1) then
                if (data[ent:MapCreationID()] != nil) then
                    local tenantsString = "This apartment belongs to "
                    PrintTable(ent.tenantTbl)
                    if (#ent.tenantTbl["name"] == 0) then
                        ent:SetNetVar("description", nil)
                    elseif (#ent.tenantTbl["name"] == 1) then
                        tenantsString = "This apartment belongs to "..ent.tenantTbl["name"][1].."."
                        ent:SetNetVar("description", tenantsString)
                        if data[ent:MapCreationID()].locked then
                            ent:Fire("lock")
                        else
                            ent:Fire("unlock")
                        end
                        ent:SetNetVar("description", tenantsString)
                    elseif (#ent.tenantTbl["name"] == 2) then
                        tenantsString = "This apartment belongs to "..ent.tenantTbl["name"][1].." and "..ent.tenantTbl["name"][2].."."
                        ent:SetNetVar("description", tenantsString)
                        if data[ent:MapCreationID()].locked then
                            ent:Fire("lock")
                        else
                            ent:Fire("unlock")
                        end
                        ent:SetNetVar("description", tenantsString)
                    elseif (#ent.tenantTbl["name"] >= 3) then
                        for k, v in ipairs(ent.tenantTbl["name"]) do
                            if (k == #ent.tenantTbl["name"]) then
                                tenantsString = tenantsString.."and "..v.."."
                                ent:SetNetVar("description", tenantsString)
                            else
                                tenantsString = tenantsString..v..", "
                                ent:SetNetVar("description", tenantsString)
                            end
                        end
                        if data[ent:MapCreationID()].locked then
                            ent:Fire("lock")
                        else
                            ent:Fire("unlock")
                        end
                        ent:SetNetVar("description", tenantsString)
                    end
                end
            end
        end
    end

    function PLUGIN:SaveTenantData()
        local data = {}

        for k, v in pairs(ents.GetAll()) do
            if (v:GetClass() == "prop_door_rotating" and v:MapCreationID() != -1) then
                data[v:MapCreationID()] = v.tenantTbl
                data[v:MapCreationID()].locked = v:IsLocked()
            end
        end

        self:SetData(data)
    end
        
    function PLUGIN:SaveData()
        self:SaveTenantData()
    end

    function PLUGIN:LoadData()
        self:LoadTenantData()
    end

end