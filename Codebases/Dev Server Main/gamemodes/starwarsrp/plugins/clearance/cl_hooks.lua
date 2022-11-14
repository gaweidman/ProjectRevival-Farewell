netstream.Hook("OpenIDCreate", function(data)
    vgui.Create("ixCreateID"):Populate(data)
end)

netstream.Hook("OpenIDManager", function(data)
    vgui.Create("ixIDManager"):Populate(data)
end)