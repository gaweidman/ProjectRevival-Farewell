ITEM.name = "Pin"
ITEM.model = Model("models/Items/CrossbowRounds.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "A push pin, capable of pinning things to walls."
ITEM.category = "Miscellaneous"

ITEM.functions.Attach = {
    icon = "icon16/attach.png",
	OnRun = function(itemTable)
        local owner = itemTable.player
        local trace = owner:GetEyeTrace()
		// Bail if we hit world or a player
        if (  !trace.Entity:IsValid() || trace.Entity:IsPlayer() || trace.Entity:GetClass() != "ix_item") then owner:Notify("That isn't a valid item!"); return false end
        
        if (trace.Hit and trace.StartPos:Distance(trace.HitPos) <= 96) then
            trace.Entity:GetPhysicsObject():EnableMotion(false)
            return true
        else
            owner:Notify("You are too far!")
            return false
        end
	end,
}