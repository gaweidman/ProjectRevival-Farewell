ITEM.name = "Axe"
ITEM.description = "A regular axe with a wooden handle."
ITEM.model = "models/weapons/yurie_rustalpha/wm-hatchet.mdl"
ITEM.class = "tfa_rustalpha_hatchet"
ITEM.weaponCategory = "melee"
ITEM.width = 3
ITEM.height = 1
/*
ITEM.iconCam = {
	pos = Vector(334.25479125977, 279.77459716797, 203.62850952148),
	ang = Angle(25, 220, 0),
	fov = 5.2866691148943,
	outline = true,
	outlineColor = Color(255, 255, 255)
}
*/
ITEM.pacData = {
    [1] = {
        ["children"] = {
            [1] = {
                ["children"] = {
                    [1] = {
                        ["children"] = {
                        },
                        ["self"] = {
                            ["Skin"] = 0,
                            ["Invert"] = false,
                            ["LightBlend"] = 1,
                            ["CellShade"] = 0,
                            ["OwnerName"] = "self",
                            ["AimPartName"] = "",
                            ["IgnoreZ"] = false,
                            ["AimPartUID"] = "",
                            ["Passes"] = 1,
                            ["Name"] = "",
                            ["NoTextureFiltering"] = false,
                            ["DoubleFace"] = false,
                            ["PositionOffset"] = Vector(0, 0, 0),
                            ["IsDisturbing"] = false,
                            ["Fullbright"] = false,
                            ["EyeAngles"] = false,
                            ["DrawOrder"] = 0,
                            ["TintColor"] = Vector(0, 0, 0),
                            ["UniqueID"] = "1391949638",
                            ["Translucent"] = false,
                            ["LodOverride"] = -1,
                            ["BlurSpacing"] = 0,
                            ["Alpha"] = 1,
                            ["Material"] = "",
                            ["UseWeaponColor"] = false,
                            ["UsePlayerColor"] = false,
                            ["UseLegacyScale"] = false,
                            ["Bone"] = "spine 2",
                            ["Color"] = Vector(255, 255, 255),
                            ["Brightness"] = 1,
                            ["BoneMerge"] = false,
                            ["BlurLength"] = 0,
                            ["Position"] = Vector(1.4322509765625, -3.576171875, -0.07177734375),
                            ["AngleOffset"] = Angle(0, 0, 0),
                            ["AlternativeScaling"] = false,
                            ["Hide"] = false,
                            ["OwnerEntity"] = false,
                            ["Scale"] = Vector(1, 1, 1),
                            ["ClassName"] = "model",
                            ["EditorExpand"] = false,
                            ["Size"] = 1,
                            ["ModelFallback"] = "",
                            ["Angles"] = Angle(60.117168426514, -167.39778137207, -165.95471191406),
                            ["TextureFilter"] = 3,
                            ["Model"] = "models/weapons/yurie_rustalpha/wm-hatchet.mdl",
                            ["BlendMode"] = "",
                        },
                    },
                },
                ["self"] = {
                    ["AffectChildrenOnly"] = false,
                    ["Invert"] = false,
                    ["RootOwner"] = true,
                    ["OwnerName"] = "self",
                    ["AimPartUID"] = "",
                    ["TargetPartUID"] = "",
                    ["Hide"] = false,
                    ["Name"] = "",
                    ["EditorExpand"] = true,
                    ["Arguments"] = "tfa_rustalpha_hatchet",
                    ["Event"] = "weapon_class",
                    ["ClassName"] = "event",
                    ["ZeroEyePitch"] = false,
                    ["IsDisturbing"] = false,
                    ["Operator"] = "equal",
                    ["UniqueID"] = "1079447602",
                    ["TargetPartName"] = "",
                },
            },
        },
        ["self"] = {
            ["DrawOrder"] = 0,
            ["UniqueID"] = "2071406711",
            ["AimPartUID"] = "",
            ["Hide"] = false,
            ["Duplicate"] = false,
            ["ClassName"] = "group",
            ["OwnerName"] = "self",
            ["IsDisturbing"] = false,
            ["Name"] = "my outfit",
            ["EditorExpand"] = true,
        },
    },    
}