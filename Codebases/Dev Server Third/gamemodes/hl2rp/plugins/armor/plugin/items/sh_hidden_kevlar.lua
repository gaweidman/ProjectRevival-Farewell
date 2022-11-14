
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Hidden Kevlar Vest";
ITEM.uniqueID = "hidden_kevlar_vest";
ITEM.actualWeight = 3;
ITEM.invSpace = 0;
ITEM.protection = 0.10;
ITEM.maxArmor = 100;
ITEM.description = "A laborer's uniform with gloves and a olive-green heavy jacket.";

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	if (SERVER) then
		return player:GetDefaultModel();
	else
		return player:GetModel();
	end;
end;

ITEM:Register();