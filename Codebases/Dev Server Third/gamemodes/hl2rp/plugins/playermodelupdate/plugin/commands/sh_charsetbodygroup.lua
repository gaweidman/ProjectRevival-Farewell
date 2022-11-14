
local COMMAND = Clockwork.command:New("CharSetBodyGroup");
COMMAND.tip = "Sets a bodygroup for a players' active model to something. Set state to -1 to use the default.";
COMMAND.text = "<string Name> <number BodyGroup> <number State>";
COMMAND.access = "a";
COMMAND.arguments = 3;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if (target) then
		local targetBodyGroups = target:GetCharacterData("bodygroups", {});
		local bodyGroupState = tonumber(arguments[3]) or 0;
		local bodyGroup = tonumber(arguments[2]) or 0;
		local model = target:GetModel();
		
		if (bodyGroup < target:GetNumBodyGroups()) then
			targetBodyGroups[model] = targetBodyGroups[model] or {};
			
			if (bodyGroupState < 0) then
				targetBodyGroups[model][tostring(bodyGroup)] = nil;

				if (#targetBodyGroups[model] == 0) then
					targetBodyGroups[model] = nil;
				end;

				target:SetCharacterData("bodygroups", targetBodyGroups);
				target:SetBodyGroups();

				if (target != player) then
					Clockwork.player:Notify(player, "You have changed "..target:Name().."'s '"..target:GetBodygroupName(bodyGroup).."' ("..bodyGroup..") bodygroup to the default one.");
					Clockwork.player:Notify(target, player:Name().."has changed your '"..target:GetBodygroupName(bodyGroup).."' ("..bodyGroup..") bodygroup to the default one.");
				else
					Clockwork.player:Notify(player, "You have set your '"..target:GetBodygroupName(bodyGroup).."' ("..bodyGroup..") bodygroup to the default one.");
				end;
			else
				targetBodyGroups[model][tostring(bodyGroup)] = bodyGroupState;

				target:SetCharacterData("bodygroups", targetBodyGroups);
				target:SetBodygroup(bodyGroup, bodyGroupState);
				
				if (target != player) then
					Clockwork.player:Notify(player, "You have changed "..target:Name().."'s '"..target:GetBodygroupName(bodyGroup).."' ("..bodyGroup..") bodygroup to "..bodyGroupState..".");
					Clockwork.player:Notify(target, player:Name().."has changed your '"..target:GetBodygroupName(bodyGroup).."' ("..bodyGroup..") bodygroup to "..bodyGroupState..".");
				else
					Clockwork.player:Notify(player, "You have set your '"..target:GetBodygroupName(bodyGroup).."' ("..bodyGroup..") bodygroup to "..bodyGroupState..".");
				end;
			end;
		else
			Clockwork.player:Notify(player, "'".. bodyGroup .. "' is not a valid bodygroup for this model!");
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
	end;
end;

COMMAND:Register();