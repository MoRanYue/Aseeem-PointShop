util.AddNetworkString('ASEEEM_PS_ServerLuaSend')
function ASEEEM_PS.func.LuaSend(ply, code)
    if IsValid(ply) then
        ASEEEM_PS.func.Net('ASEEEM_PS_ServerLuaSend', false, { data = code, type = ASEEEM_PS.enums.NetType.STRING })
        ASEEEM_PS.func.NetSend(ply)
    end
end

--F3打开
ASEEEM_PS.func.AddHook("ShowSpare1", "openShopMenuUseF3", function(ply)
    ASEEEM_PS.func.Net('callAPSMenu')
    ASEEEM_PS.func.NetSend(ply)
end)

--F3打开，O键打开
ASEEEM_PS.func.AddHook("PlayerButtonDown", "openShopMenuUseF3OrO", function(ply, btn)
    if btn == KEY_F3 or btn == KEY_O then
        ASEEEM_PS.func.Net('callAPSMenu')
        ASEEEM_PS.func.NetSend(ply)
    end
end)