
local Clockwork = Clockwork;
local PLUGIN = PLUGIN;

-- Called when the F1 Text is needed.
function PLUGIN:GetPlayerInfoText(playerInfoText)

	local paTraining = Clockwork.Client:GetSharedVar("paTraining");
	local text = "";
	if (!paTraining or paTraining == 0) then
		return;
	elseif (paTraining == 1) then
		text = "Basic";
	elseif (paTraining == 2) then
		text = "Advanced";
	elseif (paTraining == 3) then
		text = "Expert";
	end;
	
	playerInfoText:Add("PATRAINING", "PA Training: "..text);
end;

-- Called when gasmask screen space effects should be rendered.
function PLUGIN:RenderScreenspaceEffects()
	local hasGasmask = Clockwork.Client:GetSharedVar("hasGasmask");
	if (hasGasmask) then
		local health = LocalPlayer():Health();
		
		if (health <= 20) then
			DrawMaterialOverlay("effects/gasmask_screen_4.vmt", 0.1);
		elseif(health <= 30) then
			DrawMaterialOverlay("effects/gasmask_screen_3.vmt", 0.1);
		elseif(health <= 60) then
			DrawMaterialOverlay("effects/gasmask_screen_2.vmt", 0.1);
		elseif(health <= 90) then
			DrawMaterialOverlay("effects/gasmask_screen_1.vmt", 0.1);
		else
			DrawMaterialOverlay("effects/gasmask_screen.vmt", 0.1);
		end;
	end;
end;