
ITEM.name = "Civil Workers' Union ID"
ITEM.model = Model("models/dorado/tarjeta3.mdl")
ITEM.description = "A CWU identification card with ID #%s, assigned to %s."

function ITEM:GetDescription()
	return self:GetData("description", "Custom item description.")
end
