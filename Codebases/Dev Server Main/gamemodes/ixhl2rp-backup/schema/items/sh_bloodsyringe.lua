ITEM.name = "Blood Collecting Syringe"
ITEM.description = "A clear syringe for collecting blood samples. It comes with a glass vial and a stopper."
ITEM.category = "Medical"
ITEM.model = "models/illusion/eftcontainers/medsyringe.mdl"
ITEM.width = 1
ITEM.height = 1

ITEM.functions.DrawBlood = {
    name = "Draw Blood",
	icon = "icon16/group.png",
    OnRun = function(item)
        local client = item.player
        local trace = client:GetEyeTrace()
        if (trace.Entity != nil and trace.Entity:IsPlayer()) then
            local target = trace.Entity
            if (client:GetVar("drawingBlood", false)) then
                client:Notify("You are already drawing blood!")
                return false
            end

            client:SetVar("drawingBlood", true)
            local actionTime = 3
            target:SetAction("Someone is drawing your blood...", actionTime)
            client:SetAction("Drawing Blood...", actionTime)
            client:DoStaredAction(target, function()
                -- On Success
                client:SetVar("drawingBlood", false)
                if target:GetPos():Distance(client:GetPos()) <= 50 then
                    if (!client:GetCharacter():GetInventory():Add("bloodsample", 1, {["linkedChar"] = target:GetCharacter():GetID()})) then
                        ix.item.Spawn("bloodsample", client)
                    end
                    item:Remove()
                else
                    client:Notify("You are not looking at a valid target!")
                    return false
                end
            end, 3, function()
                -- On Cancel
                client:SetVar("drawingBlood", false)
                client:SetAction()
                target:SetAction()
            end, 50)
            return false
        end
    end
}