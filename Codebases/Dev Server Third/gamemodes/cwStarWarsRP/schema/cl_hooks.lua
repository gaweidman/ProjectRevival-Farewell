--[[
	© 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

-- Called when the cinematic intro info is needed.
function Schema:GetCinematicIntroInfo()
	return {
		credits = "Designed and developed by "..self:GetAuthor()..".",
		title = Clockwork.config:Get("intro_text_big"):Get(),
		text = Clockwork.config:Get("intro_text_small"):Get()
	};
end;

-- Called when a player's scoreboard class is needed.
function Schema:GetPlayerScoreboardClass(player)
	local faction = player:GetFaction();
	
	-- This will change how a faction's name appears on the scoreboard.
	if (faction == FACTION_EXAMPLE) then
		return "Example Faction";
	end;
end;

-- Called when the local player's default color modify should be set.
function Schema:PlayerSetDefaultColorModify(colorModify)
	colorModify["$pp_colour_brightness"] = 1;
	colorModify["$pp_colour_contrast"] = 1;
	colorModify["$pp_colour_colour"] = 1;
end;