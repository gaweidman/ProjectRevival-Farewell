nut.command.add("plysetjumppower", {
	adminOnly = true,
	syntax = "<string name> [number power]",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1]);
		local newPower = tonumber(arguments[2]);

		if (IsValid(target) and target:getChar()) then
			target:SetJumpPower(newPower);

			nut.util.notifyLocalized("cjumppowerSet", nil, client:Name(), target:Name(), newPower or 0);
		end
	end
});