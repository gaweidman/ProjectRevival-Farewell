/*nut.command.add("rollattr", {
	syntax = "[attribute name]",
    onRun = function(client, arguments)
        if nut.attribs[arguments[1]] != nil then
            attribVal = client:getAttribs()[arguments[1]]
            nut.chat.send(client, "rollattrib", math.random(1, 20) + math.floor(attribvVal/6.0 + 0.5), math.floor(attribvVal/6.0 + 0.5))
        end
	end
})*/

nut.command.add("testcomm", {
    syntax = "[attribute name]",
    adminOnly = true;
    adminonly = true;
    onRun = function(client, arguments)
        nut.chat.send(client, "pm", "test")
	end
})