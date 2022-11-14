local PLUGIN = PLUGIN

ix.command.Add('Apply', {
    description = 'Says your name and CID to a CP.',
    OnRun = function(self, client)
        local character = client:GetCharacter()

        if character then
            local cid = character:GetData'cid'
            
            if cid then
                ix.chat.Send(client, 'ic', client:Name()..', #'..cid)
            elseif client:HasBiosignal() then
                return 'You don´t own a CID!'
            else
                return 'You don´t own a CID!'
            end
        end
    end
})

ix.command.Add('Name', {
    description = 'Says your name.',
    OnRun = function(self, client)
        local character = client:GetCharacter()

        if character then
            ix.chat.Send(client, 'ic', client:Name())
        end
    end
})