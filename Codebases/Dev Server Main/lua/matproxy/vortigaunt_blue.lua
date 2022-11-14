VORTIGAUNT_BLUE_FADE_TIME = 2.25

matproxy.Add({
    name = "VortEmissive", 
    init = function( self, mat, values )

        local bFound;
        self.matEmissiveStrength = mat:GetFloat("$emissiveblendstrength")

        if ( self.matEmissiveStrength != nil ) then
            self.matDetailBlendStrength = mat:GetFloat("$detailblendfactor")
        end

        return bFound;
    end,
    bind = function( self, mat, ent )
        local flBlendValue;
        local isBlue = ent:GetNetVar("IsBlue", false)

        if (mat:GetName() == "models/vortigaunt/vortigaunt_blue") then
            local fadeBlueEndTime = ent:GetNetVar("fadeBlueEndTime", -1)    

            -- Do we need to crossfade?
            if (CurTime() < fadeBlueEndTime and fadeBlueEndTime != -1) then
                local fadeRatio = (fadeBlueEndTime - CurTime()) / VORTIGAUNT_BLUE_FADE_TIME;
                if (isBlue) then
                    fadeRatio = 1 - fadeRatio;
                end
                flBlendValue = math.Clamp( fadeRatio, 0, 1 )

            -- No, we do not.
            else 
                if isBlue then flBlendValue = 1 else flBlendValue = 0 end
            end
        else
            flBlendValue = 0;
        end

        if ( self.matEmissiveStrength != nil ) then
            mat:SetFloat("$emissiveblendstrength", flBlendValue)
        end

        if( self.matDetailBlendStrength != nil ) then
            mat:SetFloat("$detailblendfactor", flBlendValue)
        end
    end 
})