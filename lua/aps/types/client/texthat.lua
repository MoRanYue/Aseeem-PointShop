local texthat = {}

if ASEEEM_PS.data.itemTypes.texthat and ASEEEM_PS.data.itemTypes.texthat.client then
    texthat.data = ASEEEM_PS.data.itemTypes.texthat.client.data or {}
end

texthat.on_buy = function(item, inv_item)
end
texthat.on_equip = function(item, inv_item)
    local ply = LocalPlayer()

    local color = item['data'][1]
    local rainbow = inv_item['data'][2] or item['data'][2]
    local font = item['data'][5]

    local outline = item['data'][3]
    local size = item['data'][4]
    -- local size = 1.5
    local baseOutfit = {
        [1] = {
            ["children"] = {
                [1] = {
                    ["children"] = {
                    },
                    ["self"] = {
                        ["Outline"] = 1,
                        ["UniqueID"] = "3494032761",
                        ["Name"] = "APS_Texthat",
                        ["EditorExpand"] = true,
                        ["Position"] = Vector(15, 0, 0),
                        ["ClassName"] = "text",
                        ["Size"] = size,
                        ["Font"] = font,
                        ["Color"] = color,
                        ["OutlineColor"] = outline,
                        ["Angles"] = Angle(90, -82.253997802734, 5.1226412324468e-005),
                        ["Text"] = 'Example Text',
                    },
                },
            },
            ["self"] = {
                ["EditorExpand"] = true,
                ["UniqueID"] = "3385648173",
                ["ClassName"] = "group",
                ["Name"] = "my outfit",
                ["Description"] = "add parts to me!",
            },
        },
    }

    ASEEEM_PS.data.itemTypes.texthat.client.data.text = inv_item['data'][1] or 'NIHAO'
    ASEEEM_PS.data.itemTypes.texthat.client.data.color = color
    ASEEEM_PS.data.itemTypes.texthat.client.data.rainbow = rainbow
    ASEEEM_PS.data.itemTypes.texthat.client.data.outfit = baseOutfit

    if !ply.AttachPACPart then
        pac.SetupENT(ply)
        ply:SetShowPACPartsInEditor( false )
    end

    ply:AttachPACPart(baseOutfit, ply)

    ASEEEM_PS.func.AddHook('Think', 'TEXTHAT', function()
        local ply = LocalPlayer()

        if ply.FindPACPart and ASEEEM_PS.data.itemTypes.texthat.client then
            ply.textPart = ply:FindPACPart(ASEEEM_PS.data.itemTypes.texthat.client.data.outfit, "APS_Texthat")
        end

        if IsValid(ply.textPart) then
            ply.textPart:SetText(tostring(ASEEEM_PS.data.itemTypes.texthat.client.data.text))
            if ASEEEM_PS.data.itemTypes.texthat.client.data.rainbow then
                ply.textPart:SetColor(HSVToColor(RealTime() *20 % 360, 1, 1))
            end
        end
    end)
end
texthat.on_unequip = function(item, inv_item)
    local ply = LocalPlayer()

    ASEEEM_PS.func.RemoveHook('Think', 'TEXTHAT')

    if ply.RemovePACPart then
        ply:RemovePACPart(ASEEEM_PS.data.itemTypes.texthat.client.data.outfit)
    end
end
texthat.on_sell = function(item, inv_item)
end
texthat.on_adjust = function(item, inv_item)
end



ASEEEM_PS.data.itemTypes.texthat = ASEEEM_PS.data.itemTypes.texthat or {}
ASEEEM_PS.data.itemTypes.texthat.client = texthat

