
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "NCR Trooper Armor";
ITEM.uniqueID = "ncr_armor";
ITEM.actualWeight = 15;
ITEM.invSpace = 4.5;
ITEM.radiationResistance = 0.1;
ITEM.maxArmor = 65;
ITEM.protection = 0.35;
ITEM.business = false;
ITEM.description = "A brown and dirty set of clothing and helmet with a light kevlar vest attached.";

function ITEM:GetReplacement(player)
	if (player:GetGender() == GENDER_MALE) then
		return "models/ncr/"..string.gsub(self:GetModelName(player), "male_", "ncr_", 1);
	else
		return "models/ncr/"..self:GetModelName(player);
	end;
end;

ITEM:Register();