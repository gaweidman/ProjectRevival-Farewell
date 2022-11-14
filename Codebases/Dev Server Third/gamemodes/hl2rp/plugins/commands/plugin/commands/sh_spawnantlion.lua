
local COMMAND = Clockwork.command:New("SpawnAntlions");
COMMAND.tip = "Spawns a group of burrowed antlions.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local tr = player:GetEyeTrace();
	self:SpawnAntlion(tr.HitPos, player:EyeAngles());
	self:SpawnAntlion(tr.HitPos + Vector(80,0,0), Angle(0, player:EyeAngles().y, player:EyeAngles().r));
	self:SpawnAntlion(tr.HitPos + Vector(-80,0,0), Angle(0, player:EyeAngles().y, player:EyeAngles().r));
	self:SpawnAntlion(tr.HitPos + Vector(0,80,0), Angle(0, player:EyeAngles().y, player:EyeAngles().r));
	self:SpawnAntlion(tr.HitPos + Vector(0,-80,0), Angle(0, player:EyeAngles().y, player:EyeAngles().r));
end;

function COMMAND:SpawnAntlion(pos, ang)
	local antlion = ents.Create("npc_antlion");
	antlion:SetPos(pos + Vector(0,0,10));
	antlion:SetAngles(ang + Angle(0,180,0));
	antlion:SetKeyValue("spawnflags", "516");
	antlion:SetKeyValue("startburrowed", "1");
	antlion:Spawn();
	antlion:Activate();
	antlion:Fire("unburrow", "", 0);

	for k, v in pairs(_player.GetAll()) do 
		if (v:GetModel() == "models/synth.mdl") then
			antlion:AddEntityRelationship(v, D_LI, 99);
		end;
	end;
end;


COMMAND:Register();