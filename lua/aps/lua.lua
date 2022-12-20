util.AddNetworkString('ASEEEM_PS_ServerLuaSend')
function ASEEEM_PS.func.LuaSend(ply, code)
    if IsValid(ply) then
        ASEEEM_PS.func.Net('ASEEEM_PS_ServerLuaSend', false, { data = code, type = ASEEEM_PS.enums.NetType.STRING })
        ASEEEM_PS.func.NetSend(ply)
    end
end