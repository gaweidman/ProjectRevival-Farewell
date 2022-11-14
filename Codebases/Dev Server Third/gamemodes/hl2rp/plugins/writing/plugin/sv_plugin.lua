--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local PLUGIN = PLUGIN;

Clockwork.datastream:Hook("EditPaper", function(player, data)
	if (IsValid(data[1])) then
		if (data[1]:GetClass() == "cw_paper") then
			if (player:GetPos():Distance(data[1]:GetPos()) <= 192 and player:GetEyeTraceNoCursor().Entity == data[1]) then
				if (string.len(data[2]) > 0) then
					data[1]:SetText(string.sub(data[2], 0, 500));
				end;
			end;
		end;
	end;
end);

-- A function to load the paper.
function PLUGIN:LoadPaper()
	local paper = Clockwork.kernel:RestoreSchemaData("plugins/paper/"..game.GetMap());
	
	for k, v in pairs(paper) do
		local entity = ents.Create("cw_paper");
		
		Clockwork.player:GivePropertyOffline(v.key, v.uniqueID, entity);
		
		entity:SetAngles(v.angles);
		entity:SetPos(v.position);
		entity:Spawn();
		
		if (IsValid(entity)) then
			entity:SetText(v.text);
		end;
		
		if (!v.moveable) then
			local physicsObject = entity:GetPhysicsObject();
			
			if (IsValid(physicsObject)) then
				physicsObject:EnableMotion(false);
			end;
		end;
	end;
end;

-- A function to save the paper.
function PLUGIN:SavePaper()
	local paper = {};
	
	for k, v in pairs(ents.FindByClass("cw_paper")) do
		local physicsObject = v:GetPhysicsObject();
		local moveable;
		
		if (IsValid(physicsObject)) then
			moveable = physicsObject:IsMoveable();
		end;
		
		paper[#paper + 1] = {
			key = Clockwork.entity:QueryProperty(v, "key"),
			text = v.text,
			angles = v:GetAngles(),
			moveable = moveable,
			uniqueID = Clockwork.entity:QueryProperty(v, "uniqueID"),
			position = v:GetPos()
		};
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/paper/"..game.GetMap(), paper);
end;