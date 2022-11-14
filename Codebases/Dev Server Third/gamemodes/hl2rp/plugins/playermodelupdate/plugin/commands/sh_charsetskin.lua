
local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("CharSetSkin");
COMMAND.tip = "Sets the skin of someone's model. Set skin to -1 to use default.";
COMMAND.text = "<string Name> <number Skin>";
COMMAND.access = "a";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if (target) then
		local targetSkins = target:GetCharacterData("skins") or {};
		local skin = tonumber(arguments[2]) or 0;
		local model = target:GetModel();
		
		if (skin < target:SkinCount()) then
			if (skin < 0) then
				targetSkins[model] = nil;
				if (target != player) then
					Clockwork.player:Notify(player, target:Name().." will now use the default class/faction skin.");
					Clockwork.player:Notify(target, player:Name().." has set your skin to the default class/faction skin.");
				else
					Clockwork.player:Notify(player, "You will now use the default class/faction skin.");
				end;

				target:SetCharacterData("skins", targetSkins);
				target:SetSkin(Clockwork.plugin:Call("GetPlayerDefaultSkin", target));
			else
				targetSkins[model] = skin;
				
				target:SetSkin(skin);
				target:SetCharacterData("skins", targetSkins);
				
				if (target != player) then
					Clockwork.player:Notify(player, "You have changed " ..target:Name().. "'s skin to '"..skin.."'.");
					Clockwork.player:Notify(target, player:Name().." has set your skin to '"..skin.."'.");
				else
					Clockwork.player:Notify(player, "You have set your skin to '"..skin.."'.");
				end;
			end;
		else
			Clockwork.player:Notify(player, "'".. skin .. "' is not a valid skin for this model!");
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
	end;
end;

COMMAND:Register();