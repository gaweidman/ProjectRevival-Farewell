PLUGIN.name = "Passive Dispatch"
PLUGIN.description = "Automatic dispatch"
PLUGIN.author = "Stalker"

ix.util.Include("sv_hooks.lua")

do
	local CLASS = {}
	CLASS.color = Color(207, 23, 23)
	CLASS.format = "Dispatch broadcasts \"%s\""
	CLASS.printName = "Passive Dispatch"

	function CLASS:OnChatAdd(speaker, text)
		if text.sub(1,1) != "!" then
			chat.AddIconText("d", self.color, string.format(self.format, text))
		end
	end

	ix.chat.Register("dispatchs", CLASS)
end


do
	local CLASS = {}
	CLASS.color = Color(191, 128, 255)
	CLASS.format = "The Consul broadcasts \"%s\""
	CLASS.printName = "Radio"
	CLASS.printName = "Passive Broadcast"

	function CLASS:OnChatAdd(speaker, text)
		chat.AddIconText("d", self.color, string.format(self.format, text))
	end

	ix.chat.Register("broadcasts", CLASS)
end