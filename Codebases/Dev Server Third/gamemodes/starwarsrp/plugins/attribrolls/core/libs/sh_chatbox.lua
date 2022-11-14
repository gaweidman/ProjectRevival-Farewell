nut.chat.register("rollattrib", {
	format = "%s has rolled %s, with a modifier of %s",
	color = Color(155, 111, 176),
	filter = "actions",
    font = "nutChatFontItalics",
    onCanHear = nut.config.get("chatRange", 280),
	deadCanChat = true
})