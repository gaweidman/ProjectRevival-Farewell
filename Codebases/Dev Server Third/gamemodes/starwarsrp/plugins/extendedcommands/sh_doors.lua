nut.command.add("doorsetlocked", {
	adminOnly = true,
	syntax = "<bool locked>",
	onRun = function(client, arguments)
		local entity = client:GetEyeTrace().Entity;

		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			local locked = util.tobool(arguments[1] or true);
			if (locked) then
				entity:Fire("lock");
				entity:EmitSound("doors/door_latch3.wav");
			else
				entity:Fire("unlock");
				entity:EmitSound("doors/door_latch1.wav");
			end

			local partner = entity:getDoorPartner();
			if (IsValid(partner)) then
				if (locked) then
					partner:Fire("lock");
				else
					partner:Fire("unlock");
				end
			end
			client:notifyLocalized("dlockedSet");
		else
			client:notifyLocalized("dNotValid");
		end
	end
});