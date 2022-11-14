nut.chat.register("meclose", {
	format = "**%s %s",
	onCanHear = nut.config.get("chatRange", 280) * 0.25,
	prefix = {"/meclose", "/actionclose"},
	font = "nutChatFontItalics",
	filter = "actions",
	deadCanChat = true
});

nut.chat.register("mefar", {
	format = "**%s %s",
	onCanHear = nut.config.get("chatRange", 280) * 2,
	prefix = {"/mefar", "/actionfar"},
	font = "nutChatFontItalics",
	filter = "actions",
	deadCanChat = true
});

nut.chat.register("itclose", {
	onChatAdd = function(speaker, text)
		chat.AddText(nut.config.get("chatColor"), "**"..text)
	end,
	onCanHear = nut.config.get("chatRange", 280) * 0.25,
	prefix = {"/itclose"},
	font = "nutChatFontItalics",
	filter = "actions",
	deadCanChat = true
});

nut.chat.register("itfar", {
	onChatAdd = function(speaker, text)
		chat.AddText(nut.config.get("chatColor"), "**"..text)
	end,
	onCanHear = nut.config.get("chatRange", 280) * 2,
	prefix = {"/itfar"},
	font = "nutChatFontItalics",
	filter = "actions",
	deadCanChat = true
});

nut.chat.register("coinflip", {
	format = "%s flipped a coin and it landed on %s.",
	onCanHear = nut.config.get("chatRange", 280),
	color = Color(236, 100, 9),
	filter = "actions",
	font = "nutChatFontItalics",
	deadCanChat = false
});

nut.chat.register("announce", {
	format = "%s announces \"%s\"",
	onCanHear = nut.config.get("chatRange", 280) * 4,
	prefix = {"/announce", "/announcement"},
	color = Color(255, 150, 0),
	font = "nutChatFontBold",
	deadCanChat = false
});

nut.command.add("coinflip", {
	onRun = function(client, arguments)
		local coinSide = math.random(0, 1);
		if (coinSide > 0) then
			nut.chat.send(client, "coinflip", "Heads");
		else
			nut.chat.send(client, "coinflip", "Tails");
		end
	end,
});
