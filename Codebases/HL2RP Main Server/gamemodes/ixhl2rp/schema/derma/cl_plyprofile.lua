hook.Add("CreateMenuButtons", "ixPlyProfile", function(tabs)
	tabs["profile"] = {
		populate = function(container)
			local bg = container:Add("DPanel")
			bg:SetBackgroundColor(Color(44, 44, 44))
			bg:Dock(FILL)
			bg:DockPadding(32, 16, 32, 16)
		end,
		icon = "h",
		name = "Profile"
	}
end)