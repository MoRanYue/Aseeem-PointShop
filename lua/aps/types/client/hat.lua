local hat = {}

hat.on_buy = function(item, inv_item)
end
hat.on_equip = function(item, inv_item)
    local ply = LocalPlayer()

    local model = item['data'][1]
    local pos = inv_item['data'][1] or item['data'][2]
    local ang = inv_item['data'][2] or item['data'][3]
    local scale = inv_item['data'][3] or item['data'][4]

    local baseOutfit = {
        [1] = {
            ["children"] = {
                [1] = {
                    ["children"] = {
                    },
                    ["self"] = {
                        ["Skin"] = 0,
                        ["UniqueID"] = "6931eae5e0561ecb6afa9dffa63e2ff878d3acb4516cba9b48940eec77d3f5aa",
                        ["NoLighting"] = false,
                        ["AimPartName"] = "",
                        ["IgnoreZ"] = false,
                        ["AimPartUID"] = "",
                        ["Materials"] = "",
                        ["Name"] = "APS_Hat",
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
                        ["Angles"] = ang,
                        ["AngleOffset"] = Angle(0, 0, 0),
                        ["BoneMerge"] = false,
                        ["Color"] = Vector(1, 1, 1),
                        ["Position"] = pos,
                        ["ClassName"] = "model2",
                        ["Brightness"] = 1,
                        ["Hide"] = false,
                        ["NoCulling"] = false,
                        ["Scale"] = scale,
                        ["LegacyTransform"] = false,
                        ["EditorExpand"] = false,
                        ["Size"] = 1,
                        ["ModelModifiers"] = "",
                        ["Translucent"] = false,
                        ["BlendMode"] = "",
                        ["EyeTargetUID"] = "",
                        ["Model"] = model,
                    },
                },
            },
            ["self"] = {
                ["DrawOrder"] = 0,
                ["UniqueID"] = "8db26e3df2ab817d778fea00d61d65ac8382e1fac8c72d4a846df592a5cd5ef1",
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

    ply.hatOutfit = baseOutfit

    if !ply.AttachPACPart then
        if !pac then
            LocalPlayer():PrintMessage(HUD_PRINTTALK, '[Aseeem 点数商店] PAC调用失败。')
            return 
        end
        pac.SetupENT(ply)
        ply:SetShowPACPartsInEditor( false )
    end

    ply:AttachPACPart(baseOutfit, ply)
end
hat.on_unequip = function(item, inv_item)
    local ply = LocalPlayer()

    if ply.RemovePACPart and ply.hatOutfit then
        ply:RemovePACPart(ply.hatOutfit)
    end
end
hat.on_sell = function(item, inv_item)
end
hat.on_adjust = function(item, inv_item)
end



ASEEEM_PS.data.itemTypes.hat = ASEEEM_PS.data.itemTypes.hat or {}
ASEEEM_PS.data.itemTypes.hat.client = hat
