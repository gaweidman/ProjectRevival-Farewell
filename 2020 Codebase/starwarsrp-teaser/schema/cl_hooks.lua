netstream.Hook("EquippedRangefinder", function()
	if (IsValid(ix.gui.rangefinder)) then
		ix.gui.rangefinder:Remove()
	end
	
	vgui.Create("ixRangefinderDisplay"):SetOwner(LocalPlayer())
end)

netstream.Hook("EquippedUnRangefinder", function()
	vgui.Create("ixRangefinderDisplay"):SetOwner(LocalPlayer())
	ix.gui.rangefinder:Remove()
end)

netstream.Hook("OpenViewData", function(target, data)
    vgui.Create("ixViewData"):Populate(target, data)
end)

netstream.Hook("Frequency", function(oldFrequency)
	Derma_StringRequest("Frequency", "What would you like to set the frequency to?", oldFrequency, function(text)
		ix.command.Send("SetFreq", text)
	end)
end)