ITEM.name = "Entity Dropper"
ITEM.description = "Drops an Entity. You probably shouldnt be seeing this. tell a developer please."
ITEM.model = "models/weapons/w_package.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.entdrop = ""

ITEM.functions.Use = {
	icon = "icon16/cursor.png",
	OnRun = function(item, player, client)

			item.player:EmitSound( "physics/flesh/flesh_bloody_break.wav", 75, 200 )
				
				local ent = ents.Create( item.entdrop )
				ent:SetPos(item.player:EyePos() + ( item.player:GetAimVector() * 50))
				ent:Spawn()

		return true
	end
}
