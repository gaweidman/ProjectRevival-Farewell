local ITEM = Clockwork.item:New("armor_clothes_base", true);
ITEM.name = "Armor Clothes Base Customizable";
ITEM.uniqueID = "armor_clothes_base_customizable";
ITEM.replacement = "models/breen.mdl";
ITEM.description = "This item needs to be customized! Grab a Super Admin to do it!";

ITEM:AddData("Name", ITEM("name"), true);
ITEM:AddData("Desc", ITEM("description"), true);
ITEM:AddData("Model", ITEM("replacement"), true);
ITEM:AddData("ActualWeight", 2, true);
ITEM:AddData("RadResist", 0, true);
ITEM:AddData("Prot", 0, true);
ITEM:AddData("MaxArmor", 0, true);
ITEM:AddData("InvSpace", 0, true);
ITEM:AddData("RepairItem", nil, true);

ITEM:AddQueryProxy("name", "Name", true);
ITEM:AddQueryProxy("description", "Desc", true);
ITEM:AddQueryProxy("replacement", "Model", true);
ITEM:AddQueryProxy("actualWeight", "ActualWeight", true);
ITEM:AddQueryProxy("radiationResistance", "RadResist", true);
ITEM:AddQueryProxy("protection", "Prot", true);
ITEM:AddQueryProxy("maxArmor", "MaxArmor", true);
ITEM:AddQueryProxy("invSpace", "InvSpace", true);
ITEM:AddQueryProxy("repairItem", "RepairItem", true);

if (CLIENT) then
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

		options["Customize"] = function()
			local customData = {};
			
			Derma_StringRequest("Name", "Name of the item? Current: "..self("name", ""), "", function(text)
				if (!text) then
					text = self("name", "");
				end;
				customData.Name = text;
				
			Derma_StringRequest("Rarity",
					"Rarity of the item?\n1 is generic (white), 2 is uncommon (green), 3 is rare (blue), 4 is unique (purple), 5 is legendary (orange).", self("Rarity", "1"), function(text)
				text = tonumber(text);
				if (!text) then
					text = self("Rarity", 1);
				end;
				customData.Rarity = math.Clamp(math.Round(text), 1, 5);
					
			Derma_StringRequest("Description", "Description of the item? Current: "..self("description", ""), "", function(text)
				if (!text) then
					text = self("description", "");
				end;
				customData.Desc = text;
				
			Derma_StringRequest("Model", "Model of the item? Current: "..self("replacement", "models/error.mdl"), "", function(text)
				if (!text) then
					text = self("replacement", "models/error.mdl");
				end;
				customData.Model = text;
				
			Derma_StringRequest("Weight", "Weight of the item? Current: "..self("actualWeight", "0"), "", function(text)
				text = tonumber(text);
				if (!text) then
					text = self("actualWeight", 0);
				end;
				customData.ActualWeight = text;
				customData.PerceivedWeight = text;

			Derma_StringRequest("Inventory Space", "Amount of weight the clothes can carry in their pockets? Current: "..self("invSpace", "0"), "", function(text)
				text = tonumber(text);
				if (!text) then
					text = self("invSpace", 0);
				end;
				customData.InvSpace = text;
			
			Derma_StringRequest("Max Armor", "Max Armor of the item? Current: "..self("maxArmor", "0"), "", function(text)
				text = tonumber(text);
				if (!text) then
					text = self("maxArmor", 0);
				end;
				customData.MaxArmor = text;
			
			Derma_StringRequest("Radiation Resistance", "Radiation Resistance of the item? Current: "..self("radiationResistance", "0"), "", function(text)
				text = tonumber(text);
				if (!text) then
					text = self("radiationResistance", 0);
				end;
				customData.RadResist = math.Clamp(text, 0, 1);
				
			Derma_StringRequest("Protection", "Protection of the item? Current: "..self("protection", "0"), "", function(text)
				text = tonumber(text);
				if (!text) then
					text = self("protection", 0);
				end;
				customData.Prot = math.Clamp(text, 0, 1);

			Derma_StringRequest("Repair Item", "What item is needed to repair this? Current: "..self("repairItem", ""), "", function(text)
				if (!text) then
					text = self("repairItem", nil);
				end;
				customData.RepairItem = text;

			Derma_StringRequest("Repair Amount", "How much does each repair item repair? Current: "..self("repairAmount", 0), "", function(text)
				text = tonumber(text);
				if (!text) then
					text = self("repairItem", nil);
				end;
				customData.RepairAmount = text;
				
			Clockwork.entity:ForceMenuOption(entity, "Customize", customData);

			end); end); end); end); end); end); end); end); end); end); end);
		end;
	end
end;

Clockwork.item:Register(ITEM);