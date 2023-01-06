local texthat = {}

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

    ply.texthatText = inv_item['data'] and inv_item['data'][1] or 'EXAMPLE TEXT'
    ply.texthatColor = color
    ply.texthatRainbow = rainbow
    ply.texthatOutfit = baseOutfit

    if !ply.AttachPACPart then
        if !pac then
            LocalPlayer():PrintMessage(HUD_PRINTTALK, '[Aseeem 点数商店] PAC调用失败。')
            return 
        end
        pac.SetupENT(ply)
        ply:SetShowPACPartsInEditor(false)
    end

    ply:AttachPACPart(baseOutfit, ply)

    ASEEEM_PS.func.AddHook('Think', 'TEXTHAT', function()
        local ply = LocalPlayer()

        if ply.FindPACPart and ply.texthatOutfit then
            ply.textPart = ply:FindPACPart(ply.texthatOutfit, "APS_Texthat")
        end

        if IsValid(ply.textPart) then
            ply.textPart:SetText(tostring(ply.texthatText))
            if ply.texthatRainbow then
                ply.textPart:SetColor(HSVToColor(RealTime() *20 % 360, 1, 1))
            else
                ply.textPart:SetColor(ply.texthatColor)
            end
        end
    end)
end
texthat.on_unequip = function(item, inv_item)
    local ply = LocalPlayer()

    ASEEEM_PS.func.RemoveHook('Think', 'TEXTHAT')

    if ply.RemovePACPart and ply.texthatOutfit then
        ply:RemovePACPart(ply.texthatOutfit)
    end
end
texthat.on_sell = function(item, inv_item)
end
texthat.on_adjust = function(item, inv_item)
end



ASEEEM_PS.data.itemTypes.texthat = ASEEEM_PS.data.itemTypes.texthat or {}
ASEEEM_PS.data.itemTypes.texthat.client = texthat
ASEEEM_PS.data.itemTypes.texthat.client.data = ASEEEM_PS.data.itemTypes.texthat.client.data or {}

