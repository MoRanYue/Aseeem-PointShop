function ASEEEM_PS.func.ReadItemTypesData()
    local files, _ = file.Find('aps/types/client/*.lua', "LUA")
    for _, v in pairs(files) do
        include('aps/types/client/' .. v)
    end
end

timer.Simple(0.5, function()
    ASEEEM_PS.func.ReadItemTypesData()
end)

timer.Simple(8, function()
    ASEEEM_PS.func.Net('requestItem')
    ASEEEM_PS.func.NetServer()

    ASEEEM_PS.func.Net('requestInventory')
    ASEEEM_PS.func.NetServer()
end)