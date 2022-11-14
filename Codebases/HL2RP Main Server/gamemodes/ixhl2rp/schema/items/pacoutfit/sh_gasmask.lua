ITEM.name = "Conscript Hazmat Headpiece"
ITEM.model = Model("models/tnb/items/gasmask.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "A green combination gas mask and helmet with a rubber chestpiece meant to be fastened down."
ITEM.outfitCategory = "face"
ITEM.price = 45
ITEM.dt = DTTable()
ITEM.pacData = {
    [1] = {
        ["children"] = {
            [1] = {
                ["children"] = {
                    [1] = {
                        ["children"] = {
                        },
                        ["self"] = {
                            ["FollowAnglesOnly"] = false,
                            ["DrawOrder"] = 0,
                            ["InvertHideMesh"] = false,
                            ["TargetEntityUID"] = "",
                            ["AimPartName"] = "",
                            ["FollowPartUID"] = "",
                            ["Bone"] = "head",
                            ["ScaleChildren"] = false,
                            ["UniqueID"] = "d08aa31c69aeaf3033ad5c91ed77f90d930fe143f014cdb3204b18c1141d94c6",
                            ["MoveChildrenToOrigin"] = false,
                            ["Position"] = Vector(0, 0, 0),
                            ["AimPartUID"] = "",
                            ["Angles"] = Angle(0, 0, 0),
                            ["Hide"] = false,
                            ["Name"] = "",
                            ["Scale"] = Vector(1, 1, 1),
                            ["EditorExpand"] = false,
                            ["ClassName"] = "bone3",
                            ["Size"] = 100,
                            ["PositionOffset"] = Vector(0, 0, 0),
                            ["IsDisturbing"] = false,
                            ["AngleOffset"] = Angle(0, 0, 0),
                            ["EyeAngles"] = false,
                            ["HideMesh"] = false,
                        },
                    },
                },
                ["self"] = {
                    ["Skin"] = 0,
                    ["UniqueID"] = "5f6ff42a667084bc65105726e0d671e7a8903d5f0ab1d8123246a61aeab9e4e7",
                    ["NoLighting"] = false,
                    ["AimPartName"] = "",
                    ["IgnoreZ"] = false,
                    ["AimPartUID"] = "",
                    ["Materials"] = "",
                    ["Name"] = "",
                    ["LevelOfDetail"] = 0,
                    ["NoTextureFiltering"] = false,
                    ["PositionOffset"] = Vector(0, 0, 0),
                    ["IsDisturbing"] = false,
                    ["EyeAngles"] = false,
                    ["DrawOrder"] = 0,
                    ["TargetEntityUID"] = "",
                    ["Alpha"] = 1,
                    ["Material"] = "",
                    ["Invert"] = false,
                    ["ForceObjUrl"] = false,
                    ["Bone"] = "head",
                    ["Angles"] = Angle(0, 0, 0),
                    ["AngleOffset"] = Angle(0, 0, 0),
                    ["BoneMerge"] = true,
                    ["Color"] = Vector(1, 1, 1),
                    ["Position"] = Vector(0, 0, 0),
                    ["ClassName"] = "model2",
                    ["Brightness"] = 1,
                    ["Hide"] = false,
                    ["NoCulling"] = false,
                    ["Scale"] = Vector(1, 1, 1),
                    ["LegacyTransform"] = false,
                    ["EditorExpand"] = true,
                    ["Size"] = 0.1,
                    ["ModelModifiers"] = "",
                    ["Translucent"] = false,
                    ["BlendMode"] = "",
                    ["EyeTargetUID"] = "",
                    ["Model"] = "models/ddok1994/1980_hazmat.mdl",
                },
            },
            [2] = {
                ["children"] = {
                },
                ["self"] = {
                    ["FollowAnglesOnly"] = false,
                    ["DrawOrder"] = 0,
                    ["InvertHideMesh"] = false,
                    ["TargetEntityUID"] = "",
                    ["AimPartName"] = "",
                    ["FollowPartUID"] = "",
                    ["Bone"] = "head",
                    ["ScaleChildren"] = false,
                    ["UniqueID"] = "d37470dd4db46e1a8a4d92e0469ce1a81398ece979ef268a6863bfb7efa1bf77",
                    ["MoveChildrenToOrigin"] = false,
                    ["Position"] = Vector(0, 0, 0),
                    ["AimPartUID"] = "",
                    ["Angles"] = Angle(0, 0, 0),
                    ["Hide"] = false,
                    ["Name"] = "",
                    ["Scale"] = Vector(1, 1, 1),
                    ["EditorExpand"] = false,
                    ["ClassName"] = "bone3",
                    ["Size"] = 0.1,
                    ["PositionOffset"] = Vector(0, 0, 0),
                    ["IsDisturbing"] = false,
                    ["AngleOffset"] = Angle(0, 0, 0),
                    ["EyeAngles"] = false,
                    ["HideMesh"] = false,
                },
            },
        },
        ["self"] = {
            ["DrawOrder"] = 1,
            ["UniqueID"] = "d0362b8a34fafba1b72a54d32c2b45f02d765bd6d0ed34427c3dc3669db4cd0e",
            ["Hide"] = false,
            ["TargetEntityUID"] = "",
            ["EditorExpand"] = true,
            ["OwnerName"] = "self",
            ["IsDisturbing"] = false,
            ["Name"] = "my outfit",
            ["Duplicate"] = false,
            ["ClassName"] = "group",
        },
    },
    
}
function ITEM:PopulateTooltip(tooltip)
	local notice = tooltip:AddRow("obselenotice")

	tooltip:GetRow("name"):SetZPos(1)
	tooltip:GetRow("description"):SetZPos(3)

	notice:SetText("This item is still being tested, it might be removed or changed at a later date.")
	notice:SetBackgroundColor(Color(164, 55, 55))
	notice:SetZPos(2)
	notice:SizeToContents() 
end
