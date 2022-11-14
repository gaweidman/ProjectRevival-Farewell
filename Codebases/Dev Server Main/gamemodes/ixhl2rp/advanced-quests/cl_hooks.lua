local PLUGIN = PLUGIN

hook.Add("CreateMenuButtons", "ixCharacterJournal", function(tabs)
	tabs["Quests"] = function(container)
		container:Add("ixCharacterJournal")
	end
end)