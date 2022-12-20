ASEEEM_PS.data.itemTypes.start = {}

ASEEEM_PS.data.itemTypes.start.class = "start"
ASEEEM_PS.data.itemTypes.start.display = "开始"
ASEEEM_PS.data.itemTypes.start.purchasable = true

ASEEEM_PS.data.itemTypes.start.on_buy = function(itm, ply)
    PrintMessage(HUD_PRINTTALK, ply:Name() .. '买了' .. itm.name)
    for _, v in pairs(itm.data) do
        PrintMessage(HUD_PRINTTALK, v)
    end
end
ASEEEM_PS.data.itemTypes.start.on_equip = function(itm, ply)
    PrintMessage(HUD_PRINTTALK, ply:Name() .. '装备了' .. itm.name)
    ASEEEM_PS.func.AddHook("PlayerSay", itm.class .. "_repeatSaying", function(sender, txt, t_chat)
        PrintMessage(HUD_PRINTTALK, sender:Name() .. "说：" .. txt)
    end)
end
ASEEEM_PS.data.itemTypes.start.on_unequip = function(itm, ply)
    ASEEEM_PS.func.RemoveHook('PlayerSay', itm.class .. '_repeatSaying')
end
ASEEEM_PS.data.itemTypes.start.on_sell = function(itm, ply)
end
ASEEEM_PS.data.itemTypes.start.on_adjust = function(itm, ply)
end