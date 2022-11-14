local PLUGIN = PLUGIN

function PLUGIN:PopulateCharacterInfo(client, character, tooltip)
    local rank = character:GetRank()
    local classTable = ix.class.Get(client:GetCharacter():GetClass())

    if (client:GetCharacter():GetClass() == nil) then
        return
    end
    
    if (rank) and classTable.Ranks and classTable.Ranks[rank] then
        local rowRank = tooltip:AddRowAfter("name", "rank")
        rowRank:SetBackgroundColor(team.GetColor(client:Team()), rowRank)
        rowRank:SetText(classTable.Ranks[rank][1])
        rowRank:SizeToContents()
        if classTable.Ranks[rank][2] then
            local x, y = rowRank:GetTextSize()
            icon = rowRank:Add( "DImageButton")
            icon:SetPos(x + 8, y - 15.5)
            icon:SetImage(classTable.Ranks[rank][2])
            icon:SizeToContents()
        end
    end
end