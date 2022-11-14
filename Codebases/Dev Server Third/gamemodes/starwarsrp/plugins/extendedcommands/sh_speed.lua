nut.command.add("plysetwalkspeed", {
	adminOnly = true,
	syntax = "<string name> [number speed]",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1]);
		local newSpeed = tonumber(arguments[2]);

		if (IsValid(target) and target:getChar()) then
			target:SetWalkSpeed(newSpeed);

			nut.util.notifyLocalized("cwalkspeedSet", nil, client:Name(), target:Name(), newSpeed or 0);
		end
	end
});

nut.command.add("plysetrunspeed", {
	adminOnly = true,
	syntax = "<string name> [number speed]",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1]);
		local newSpeed = tonumber(arguments[2]);

		if (IsValid(target) and target:getChar()) then
			target:SetRunSpeed(newSpeed);

			nut.util.notifyLocalized("crunspeedSet", nil, client:Name(), target:Name(), newSpeed or 0);
		end
	end
});