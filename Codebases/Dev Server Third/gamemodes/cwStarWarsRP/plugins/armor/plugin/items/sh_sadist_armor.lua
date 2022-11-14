
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Raider Sadist Armor";
ITEM.uniqueID = "raider_sadist_armor";
ITEM.actualWeight = 15;
ITEM.invSpace = 3;
ITEM.radiationResistance = 0.05;
ITEM.maxArmor = 55;
ITEM.protection = 0.35;
ITEM.business = false;
ITEM.description = "A full suit of sadist armor created hastily by a raider tribe.";

function ITEM:GetReplacement(player) 
	if (player:GetGender() == GENDER_MALE) then
		return "models/Fallout3/sadistmaleraider.mdl" 
	else 
		return "models/Fallout3/sadistfemaleraider.mdl"
	end;
end;


ITEM:Register();