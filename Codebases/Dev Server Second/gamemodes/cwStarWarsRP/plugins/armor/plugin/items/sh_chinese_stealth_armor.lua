
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Chinese Stealth Armor";
ITEM.uniqueID = "chinese_stealth_armor";
ITEM.actualWeight = 3;
ITEM.radiationResistance = 0;
ITEM.protection = 0.3;
ITEM.hasGasmask = false;
ITEM.isPA = false;
ITEM.business = false;
ITEM.description = "A stealth suit created by the Chinese during the Great War.";

function ITEM:GetReplacement(player)
	if (player:GetGender() == GENDER_FEMALE) then
		return "models/ninja/chinese_f_npc.mdl";
	else
		return "models/ninja/chinese_f_npc.mdl";
	end;
end;

ITEM:Register();
