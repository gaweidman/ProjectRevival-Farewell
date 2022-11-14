local ITEM = Clockwork.item:New(nil, true);

ITEM.name = "Stationary Radio";
ITEM.uniqueID = "stationary_radio_base";
ITEM.model = "models/props_lab/citizenradio.mdl";
ITEM.weight = 5;
ITEM.category = "Communication";
ITEM.business = false;
ITEM.tuningDisabled = false;
ITEM.frequencyID = "freq_0000";
ITEM.description = "An antique radio, do you think this'll still work?";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local trace = player:GetEyeTraceNoCursor();
	
	if (trace.HitPos:Distance( player:GetShootPos() ) <= 192) then
		local radio = ents.Create("cw_itemradio");
		
		Clockwork.player:GiveProperty(player, radio);
		
		radio:SetItemTable(self);
		radio:SetModel(self.model);
		radio:SetPos(trace.HitPos);
		radio:Spawn();

		if (self("frequencyID")) then
			radio:SetFrequency(self("frequencyID"));
		end;

		if (self("tuningDisabled")) then
			radio:SetDisableChannelTuning(true);
		end;
		
		if (IsValid(itemEntity)) then
			local physicsObject = itemEntity:GetPhysicsObject();
			
			radio:SetPos( itemEntity:GetPos() );
			radio:SetAngles( itemEntity:GetAngles() );
			
			if (IsValid(physicsObject)) then
				if (!physicsObject:IsMoveable()) then
					physicsObject = radio:GetPhysicsObject();
					
					if (IsValid(physicsObject)) then
						physicsObject:EnableMotion(false);
					end;
				end;
			end;
		else
			Clockwork.entity:MakeFlushToGround(radio, trace.HitPos, trace.HitNormal);
		end;
	else
		Clockwork.player:Notify(player, "You cannot drop a radio that far away!");
		
		return false;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();