local plugin = PLUGIN
local distance, classname = 335, "npc_combine_camera"
local _blacklist_weapon = {
    ["weapon_smg1"] = true,
    ["weapon_shotgun"] = true,
    ["weapon_slam"] = true,
    ["weapon_rpg"] = true,
    ["weapon_ar2"] = true,
    ["weapon_stunstick"] = true,
    ["weapon_frag"] = true,
    ["weapon_crowbar"] = true,
    ["weapon_crossbow"] = true,
    ["weapon_pistol"] = true
}

-- idk why i do this
function plugin:EmitQueuedSound(ent, t_sound)
    return ix.util.EmitQueuedSounds(ent, t_sound, 0, 0.1, 75, 100)
end

function plugin:Think()
    for _, ent in pairs(ents.FindByClass(classname)) do
        for _, pl in pairs(ents.FindInSphere(ent:GetPos(), distance)) do
            if not (pl:IsPlayer() and ent:IsLineOfSightClear(pl:GetPos())) then -- If camera isn't triggered or ent is not player then ignore
                continue
            end

            if (pl:HasBiosignal()) then continue end -- If player is combine ignore
            
            if (pl:GetNoDraw()) then continue end -- If player is in observer ignore

            local charDesc = pl:GetCharacter():GetDescription()
            if (string.len(charDesc) > 75) then
                charDesc = string.sub(charDesc, 1, 75)
            end

            if _blacklist_weapon[pl:GetActiveWeapon():GetClass()] and (pl.b_CameraScanDelay or 0) < CurTime() then -- Custom check, if you want you can change this
                Schema:AddCombineDisplayMessage("Firearm/Explosive caught on "..ent:GetNetVar("CameraName", "UNDEFINED NAME").."!", Color(237, 140, 66, 255))
                Schema:AddCombineDisplayMessage(" - Appearance: "..charDesc.."...", Color(237, 140, 66, 255))

                ent:Fire("SetAngry")

                ent:_SetSimpleTimer(5, function()
                    ent:Fire("SetIdle")
                end)

                pl.b_CameraScanDelay = CurTime() + 5
            end

            local xvel = pl:GetVelocity()[1]
            local yvel = pl:GetVelocity()[2]
            local zvel = pl:GetVelocity()[3]
            local absVel = math.sqrt(xvel*xvel + yvel*yvel + zvel*zvel)

            if ((absVel >= pl:GetRunSpeed() or !pl:IsOnGround()) and (pl.b_CameraScanDelay or 0) < CurTime()) then
                Schema:AddCombineDisplayMessage("Movement violation caught on "..ent:GetNetVar("CameraName", "UNDEFINED NAME").."!", Color(237, 140, 66, 255))
                Schema:AddCombineDisplayMessage(" - Appearance: "..charDesc.."...", Color(237, 140, 66, 255))
                ent:Fire("SetAngry")

                ent:_SetSimpleTimer(5, function()
                    ent:Fire("SetIdle")
                end)

                pl.b_CameraScanDelay = CurTime() + 5
            end
        end
    end
end

-- No breakable camera
function plugin:EntityTakeDamage(target, dmginfo)
    if target:GetClass() == classname then
        dmginfo:SetDamage(0)
    end
end