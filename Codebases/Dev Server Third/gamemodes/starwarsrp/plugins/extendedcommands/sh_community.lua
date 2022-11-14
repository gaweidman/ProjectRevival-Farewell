nut.config.add("contentLink", "", "The link to the server's content.", nil, {
	category = "community"
});

nut.config.add("forumLink", "", "The link to the server's forums.", nil, {
	category = "community"
});

nut.config.add("discordLink", "", "The link to the server's discord.", nil, {
	category = "community"
});

nut.command.add("content", {
	onRun = function(client, arguments)
		local contentLink = nut.config.get("contentLink");

		if (contentLink != "") then
			client:SendLua("gui.OpenURL(\"" .. contentLink .. "\")");
		end
	end
});

nut.command.add("forums", {
	onRun = function(client, arguments)
		local forumLink = nut.config.get("forumLink");

		if (forumLink != "") then
			client:SendLua("gui.OpenURL(\"" .. forumLink .. "\")");
		end
	end
});

nut.command.add("discord", {
	onRun = function(client, arguments)
		local discordLink = nut.config.get("discordLink");

		if (contentLink != "") then
			client:SendLua("gui.OpenURL(\"" .. discordLink .. "\")");
		end
	end
});