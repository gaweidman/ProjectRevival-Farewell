local PLUGIN = PLUGIN
PLUGIN.name = "Fancy /Me"
PLUGIN.description = "Distance based /me and /it commands/"
PLUGIN.author = "liquid"

ix.config.Add("chatActionYRange", 1000, "The maximum distance a yelling (/MeY, /ItY) action can go.", nil, {
	data = {min = 10, max = 5000, decimals = 1},
	category = "chat"
})

ix.config.Add("chatActionWRange", 75, "The maximum distance a whispering (/MeW, /ItW) action can go.", nil, {
	data = {min = 10, max = 5000, decimals = 1},
	category = "chat"
})

-- y
-- w
-- l

function PLUGIN:InitializedChatClasses()

    local function CanSay(self, speaker, text)
        local tr = speaker:GetEyeTrace()
        
        if IsValid(tr.Entity) and tr.Entity:IsPlayer()
        and speaker:GetPos():Distance(tr.Entity:GetPos()) < ix.config.Get("chatRange", 280) * .2 then
            tr.Entity.ixChatActionPlayer = speaker
            return true
        end

        print(speaker)

        return false
    end

    local function CanHear(self, speaker, listener)
        print(speaker, listener)
        if speaker == listener then return true end

        if listener.ixChatActionPlayer == speaker then
            listener.ixChatActionPlayer = nil
            return true
        end

        return false
    end
end