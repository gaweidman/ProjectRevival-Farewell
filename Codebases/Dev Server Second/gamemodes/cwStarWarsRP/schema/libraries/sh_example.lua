--[[
	© 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

Schema.example = Clockwork.kernel:NewLibrary("Example");

-- An example function of the Example library.
function Schema.example:KillAll()
	for k, v in ipairs(player.GetAll()) do
		v:Kill();
	end;
end;