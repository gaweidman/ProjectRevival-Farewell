nut.command.add("showmodel", {
	syntax = "",
	onRun = function(client, arguments)
		nut.chat.send(client, "model", client.GetModel())
	end
})