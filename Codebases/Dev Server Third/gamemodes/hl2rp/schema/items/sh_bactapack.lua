--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();

ITEM.name = "Bacta Pack";
ITEM.uniqueID = "touch_pickup_752_bacta_large";
ITEM.cost = 30;
ITEM.model = "models/starwars/items/bacta_large.mdl";
ITEM.weight = 1;
ITEM.useText = "Apply";
ITEM.category = "Medical"
ITEM.business = false;
ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A six-pack of bacta vials. It's warm to the touch.";
ITEM.customFunctions = {"Give"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth(math.Clamp(player:Health() + Schema:GetHealAmount(player, 2), 0, player:GetMaxHealth()));
	
	Clockwork.plugin:Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Give") then
			Clockwork.player:RunClockworkCommand(player, "CharHeal", "health_kit");
		end;
	end;
end;

ITEM:Register();