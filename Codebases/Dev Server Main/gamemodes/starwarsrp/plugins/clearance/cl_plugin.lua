hook.Add( "PreDrawHalos", "AddPropHalos", function()
    if (LocalPlayer():GetNetVar("selectedReaderID", nil) != nil) then
        for k, v in ipairs(ents.FindByClass("ix_reader")) do
            if (v:EntIndex() == LocalPlayer():GetNetVar("selectedReaderID", nil)) then
                local entities = {v}
                halo.Add( entities, Color(0, 255, 0), 5, 5, 2 )
            end
        end
    end
end)