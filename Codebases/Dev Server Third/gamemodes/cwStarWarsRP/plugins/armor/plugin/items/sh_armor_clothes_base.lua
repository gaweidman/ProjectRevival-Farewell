
local Clockwork = Clockwork;

local ITEM = Clockwork.item:New("clothes_base", true);
ITEM.name = "Armor Clothes Base";
ITEM.uniqueID = "armor_clothes_base";
ITEM.model = "models/props_c17/suitcase_passenger_physics.mdl";
ITEM.actualWeight = 2;
ITEM.invSpace = 2;
ITEM.protection = 0;
ITEM.maxArmor = 0;
ITEM.hasGasmask = false;
ITEM.hasRebreather = false;
ITEM.isPA = false;
ITEM.useText = "Wear";
ITEM.category = "Clothing";
ITEM.description = "A suitcase full of clothes.";

ITEM:AddData("armor", -1, true);
ITEM:AddData("Rarity", 1, true);
ITEM:AddData("PerceivedWeight", -1, true);
ITEM:AddData("AddInvSpace", 0, true);

ITEM:AddQueryProxy("color", ITEM.GetRarityColor);
ITEM:AddQueryProxy("weight", "PerceivedWeight");
ITEM:AddQueryProxy("addInvSpace", "AddInvSpace");

-- Called when a player wears the accessory.
function ITEM:OnChangedClothes(player, bIsWearing)
	if (bIsWearing) then
		-- Player is putting armor on
		-- Set player armor value to current remaining armor
		player:SetMaxArmor(self("maxArmor"));
		player:SetArmor(self:GetData("armor"));

		-- Set perceived weight to 0
		self:SetData("PerceivedWeight", 0);

		-- Allow armor pockets to be used for inventory weight
		self:SetData("AddInvSpace", self("invSpace"));
	else
		-- Player is taking item off
		-- Save armor on item and reset player's armor value
		self:SetData("armor", math.Clamp(player:Armor(), 0, self("maxArmor")));
		player:SetArmor(0);

		-- Set perceived weight back to the actual weight
		self:SetData("PerceivedWeight", self("actualWeight"));

		-- Remove pocket space
		self:SetData("AddInvSpace", 0);
	end;
end;

-- Called when a player has unequipped the item.
function ITEM:OnPlayerUnequipped(player, extraData)
	if (self("hasGasmask")) then
		local items = player:GetInventory();
		for k, itemList in pairs(items) do
			for k, item in pairs(itemList) do
				if (!item:IsBasedFrom("filter_base")) then
					break;
				elseif (item:GetData("equipped")) then
					hasEquipped = true;
					Clockwork.player:Notify(player, "You need to unscrew your filter first!");
					return false;
				end;
			end;
		end;
	end;

	if (player:GetInventoryWeight() + self("actualWeight") > (player:GetMaxWeight() - self("addInvSpace"))) then
		Clockwork.player:Notify(player, "You don't have enough inventory space to unequip this!");
		return false;
	end;
	
	player:RemoveClothes();
end;

function ITEM:CanGiveStorage(player, storageTable)
	if (player:IsWearingItem(self)) then
		Clockwork.player:Notify(player, "You cannot store this while you are wearing it!");
		return false;
	end;
end;

-- Called when a player attempts to take the item from storage.
function ITEM:CanTakeStorage(player, storageTable)
	local target = Clockwork.entity:GetPlayer(storageTable.entity);
	
	if (target) then
		if (target:GetInventoryWeight() > (target:GetMaxWeight() - self("addInvSpace"))) then
			return false;
		end;
	end;
end;

-- A function to get the item's rarity color.
function ITEM:GetRarityColor()
	local rarity = self:GetData("Rarity");
	if (rarity == 1) then
		return Color(248, 248, 255, 255);
	elseif (rarity == 2) then
		return Color(61, 210, 11, 255);
	elseif (rarity == 3) then
		return Color(47, 120, 255, 255);
	elseif (rarity == 4) then
		return Color(145, 50, 200, 255);
	elseif (rarity == 5) then
		return Color(255, 150, 0, 255);
	end;
end;

function ITEM:EntityHandleMenuOption(player, entity, option, argument)
	-- Armor repair
	if (option == "Repair") then
		self:RepairArmor(player);

	-- Admin armor repair
	elseif (option == "AdminRepair") then
		if (player:IsSuperAdmin()) then
			self:SetData("armor", self("maxArmor"));
			Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, player:Name().." has admin-repaired a "..self("name")..".");
		else
			Clockwork.Notify(player, "You are not a super admin!");
		end;
	end;
end;

if (SERVER) then
	function ITEM:OnInstantiated()
		-- Set initial values of the data fields
		if (self:GetData("armor") == -1) then
			self:SetData("armor", self("maxArmor"));
		end;

		if (self:GetData("PerceivedWeight") == -1) then
			self:SetData("PerceivedWeight", self("actualWeight"));
		end;

		-- Set PA footstep sounds if it's PA.
		if (self("isPA")) then
			self.runSound = {
				"newvegas/fst_armorpower_01.wav",
				"newvegas/fst_armorpower_02.wav",
				"newvegas/fst_armorpower_03.wav"
			}
			self.walkSound = self.runSound;
		end;
	end;

	function ITEM:RepairArmor(player)
		if (!self("repairItem")) then
			Clockwork.player:Notify(player, "This item cannot be repaired! (Contact a dev if it should be)");
			return;
		end;
		if (self:GetData("armor") == self("maxArmor")) then
			Clockwork.player:Notify(player, "This item already has full armor!");
			return;
		end;

		-- Check if a flag is required and if the player has it
		if (self("repairFlag") and !Clockwork.player:HasFlags(player, self("repairFlag"))) then
			Clockwork.player:Notify(player, "You do not have the "..self("repairFlag").." flag!");
		end;

		local repairItem = player:FindItemByID(self("repairItem"));

		-- Check if the player has the needed item
		if (!player:HasItemByID(self("repairItem"))) then
			repairItem = Clockwork.item:CreateInstance(self("repairItem"));
			Clockwork.player:Notify(player, "You do not have enough "..repairItem("name").." to repair this!");
			return;
		end;

		local amount = self("repairAmount") or 50;

		-- Take the repair item
		player:TakeItem(repairItem);
		-- Set armor to new value
		self:SetData("armor", math.Clamp(self:GetData("armor") + amount, 0, self("maxArmor")));
		-- Notify player
		Clockwork.player:Notify(player, "You have repaired the "..self("name").." for "..tostring(amount).." armor.");
		Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has repaired a "..self("name").." for "..tostring(amount)..".");
	end;
else
	function ITEM:GetClientSideInfo()
		if (!self:IsInstance()) then return; end;

		local clientSideInfo = "";

		local itemRarity = self:GetData("Rarity");
		if (itemRarity == 1) then
			clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Common", self:GetRarityColor());
		elseif (itemRarity == 2) then
			clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Uncommon", self:GetRarityColor());
		elseif (itemRarity == 3) then
			clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Rare", self:GetRarityColor());
		elseif (itemRarity == 4) then
			clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Unique", self:GetRarityColor());
		elseif (itemRarity == 5) then
			clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Legendary", self:GetRarityColor());
		end;

		local armor = self:GetData("armor");
		if (Clockwork.player:IsWearingItem(self)) then
			armor = Clockwork.Client:Armor();
		end;
		
		clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Armor: "..math.floor(armor));
		clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Protection: "..math.floor(100 * self("protection")).."%");
		
		return (clientSideInfo != "" and clientSideInfo);
	end;

	-- Called when the item entity's menu options are needed.
	function ITEM:GetEntityMenuOptions(entity, options)
		if (!IsValid(entity)) then
			return;
		end;

		if (Clockwork.Client:IsSuperAdmin()) then
			options["AdminRepair"] = function()
				Clockwork.entity:ForceMenuOption(entity, "AdminRepair", nil);
			end;
		end;

		options["Repair"] = function()
			Clockwork.entity:ForceMenuOption(entity, "Repair", nil);
		end;
	end;
end;

Clockwork.item:Register(ITEM);