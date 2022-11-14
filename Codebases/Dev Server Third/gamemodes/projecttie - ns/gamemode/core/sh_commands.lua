nut.command.add("broadcast", {
	syntax = "<string message>",
	onRun = function(client, arguments)
		local message = table.concat(arguments, " ", 2)
		nut.chat.send(client, "pm", message, false, {client, target})
	end
})