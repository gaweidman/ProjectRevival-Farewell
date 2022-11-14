AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Genecoder"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.bNoPersist = true

if (SERVER) then

    function ENT:Initialize()
        self:SetModel( "models/props_combine/combine_interface003.mdl" )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        
        self:SetUseType( SIMPLE_USE )
    end

    function ENT:Use( ply, caller )
        local startPos, endPos, matchedText = string.find(ply:GetName(), "GRID")
        if (!ply:HasBiosignal()) then
            ply:Notify("You do not have a biosignal!")
            return
        elseif (ply:HasBiosignal() and startPos == nil) then
            ply:Notify("You do not know how to do this!")
            return
        else
            local client = ply
            local character = client:GetCharacter()
            local inv = character:GetInventory()

            local bloodSample = inv:HasItem("bloodsample")
            local lockableWeapons = {
                "ar1",
                "ar2",
                "combinescattergun",
                "combinesniper",
                "pulsesmg",
                "suppression"
            }


            local lockableItem
            for x = 1, 6 do
                for y = 1, 4 do
                    local item = inv:GetItemAt(x, y)
                    if (item == nil) then
                        continue
                    end

                    if (item.canGenelock) then
                        lockableItem = item
                        break
                    else
                        continue
                    end
                end
            end

            

            if (bloodSample == false) then
                ply:Notify("You do not have a blood sample!")
                return
            end

            
            if (lockableItem == nil) then
                ply:Notify("You have no items that can be genecoded!")
                return
            end

            if lockableItem:GetData("lockedChar", nil) != nil then
                ply:Notify("This item has already been genecoded!")
                return
            end
            
            self:EmitSound("ambient/machines/combine_shield_touch_loop1.wav")
            client:SetAction("Genecoding Item...", 8)
            client:DoStaredAction(self, function()
                -- On Success
                self:StopSound("ambient/machines/combine_shield_touch_loop1.wav")
                self:EmitSound("npc/scanner/combat_scan1.wav")
                
                lockableItem:SetData("lockedChar", bloodSample:GetData("linkedChar"))
                bloodSample:Remove()
                ply:Notify("Weapon successfully genecoded.")
            end, 8, function()
                -- On Cancel
                self:StopSound("ambient/machines/combine_shield_touch_loop1.wav")
                self:EmitSound("items/suitchargeno1.wav")
                client:SetAction()
            end)
        end
    end

end

if (CLIENT) then
    ENT.PopulateEntityInfo = true

    function ENT:OnPopulateEntityInfo(tooltip)
        local name = tooltip:AddRow("name")
        name:SetImportant()
        name:SetText("Genecoding Machine")
        name:SizeToContents()

        local description = tooltip:AddRow("description")
        description:SetText("A locker-looking machine with various doors and panels on it.")
        description:SizeToContents()
    end
end