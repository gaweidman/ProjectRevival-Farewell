local ITEM = Clockwork.item:New();
ITEM.name = "RP Item Customisable";
ITEM.uniqueID = "rp_item_base";
ITEM.model = "models/props_lab/cactus.mdl";
ITEM.description = "An object used by SA to create RP items.";
ITEM.category = "Divers";

ITEM:AddData("Name", ITEM("name"), true);
ITEM:AddData("Desc", ITEM("description"), true);
ITEM:AddData("Model", ITEM("model"), true);
ITEM:AddData("Weight", 1, true);
ITEM:AddData("Category", ITEM("category"), true);

ITEM:AddQueryProxy("name", "Name", true);
ITEM:AddQueryProxy("description", "Desc", true);
ITEM:AddQueryProxy("model", "Model", true);
ITEM:AddQueryProxy("weight", "Weight", true);
ITEM:AddQueryProxy("category", "Category", true);

if (CLIENT) then
	-- Called when the item entity's menu options are needed.
	function ITEM:GetEntityMenuOptions(entity, options)
			if (!IsValid(entity)) then
				return;
			end;
			options["Customize"] = function()
				local customData = {};
				
				Derma_StringRequest("Name", "Name ? Current: "..self("name", ""), self("name", ""), function(text)
					if (!text or text == "") then
						text = self("name", "");
					end;
					customData.Name = text;
					
				Derma_StringRequest("Description", "Description ? Current: "..self("description", ""), self("description", ""), function(text)
					if (!text) then
						text = self("description", "");
					end;
					customData.Desc = text;
					
				Derma_StringRequest("Model", "Model? Current: "..self("model", "models/error.mdl"), self("model", ""), function(text)
					if (!text or text == "") then
						text = self("model", "models/error.mdl");
					end;
					customData.Model = text;
					
				Derma_StringRequest("Weight", "Weight ? Current: "..self("actualWeight", "0"), self("weight", "0"), function(text)
					text = tonumber(text);
					if (!text) then
						text = self("weight", 0);
					end;
					customData.Weight = text;
					customData.PerceivedWeight = text;
					
				Derma_StringRequest("Category", "Category ? Current: "..self("category", "0"), self("category", ""), function(text)
					text = tonumber(text);
					if (!text) then
						text = self("category", 0);
					end;
					customData.Category = text;
					
				Clockwork.entity:ForceMenuOption(entity, "Customize", customData);

			end); end); end); end); end);
		end;
	end;
end;

function ITEM:OnDrop(player, position) end;

ITEM:Register();