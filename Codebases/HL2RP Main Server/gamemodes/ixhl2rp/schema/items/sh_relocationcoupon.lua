
ITEM.name = "Relocation Coupon"
ITEM.model = Model("models/gibs/metal_gib4.mdl")
ITEM.description = "A relocation coupon to City 17, assigned to %s, CID no. %s."

function ITEM:GetDescription()
	return string.format(self.description, self:GetData("name", "nobody"), self:GetData("id", "00000") )
end
