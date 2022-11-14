ITEM.name = "Stealth Boy"
ITEM.model = "models/mosi/fallout4/props/aid/stealthboy.mdl"
ITEM.description = "itemStealthboyDesc"
ITEM.price = 100

ITEM.functions.Use = {
	OnRun = function(item)
		local client = item.player
		local oldColor = client:GetColor() or Color( 255, 255, 255, 255 )
		local stealthColor = Color( 255, 255, 255, 25 )
		
		client:SetColor(stealthColor)
		client:SetRenderMode( RENDERMODE_TRANSALPHA )
		client:SetNoTarget(true)
		client:DrawShadow(false)
		client:EmitSound("items/suitchargeok1.wav")
		
		timer.Simple(120, function()
			client:SetColor(oldColor)
			client:EmitSound("items/suitchargeno1.wav")
			client:SetRenderMode( RENDERMODE_TRANSALPHA )
			client:SetNoTarget(false)
			client:DrawShadow(true)
		end)
	end
}