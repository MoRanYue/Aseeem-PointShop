function ASEEEM_PS.func.NetReceive(network_string, cb)
    net.Receive(network_string, function(len, ply)
        local compressTypeBytes = net.ReadUInt(32)
        local compressTypeData = util.JSONToTable(util.Decompress(net.ReadData(compressTypeBytes)))

        if compressTypeData == {} then
            cb(len)
            return
        end

        --获取数据
        local data = {}
        for _, v in pairs(compressTypeData) do
            local temp
            if v[1] == ASEEEM_PS.enums.NetType.ANGLE then
                temp = net.ReadAngle()
            elseif v[1] == ASEEEM_PS.enums.NetType.BIT then
                temp = net.ReadBit()
            elseif v[1] == ASEEEM_PS.enums.NetType.BOOL then
                temp = net.ReadBool()
            elseif v[1] == ASEEEM_PS.enums.NetType.COLOR then
                temp = net.ReadColor(v[2])
            elseif v[1] == ASEEEM_PS.enums.NetType.DATA then
                temp = net.ReadData(v[2])
            elseif v[1] == ASEEEM_PS.enums.NetType.DOUBLE then
                temp = net.ReadDouble()
            elseif v[1] == ASEEEM_PS.enums.NetType.ENTITY then
                temp = net.ReadEntity()
            elseif v[1] == ASEEEM_PS.enums.NetType.FLOAT then
                temp = net.ReadFloat()
            elseif v[1] == ASEEEM_PS.enums.NetType.INT then
                temp = net.ReadInt(v[2])
            elseif v[1] == ASEEEM_PS.enums.NetType.MATRIX then
                temp = net.ReadMatrix()
            elseif v[1] == ASEEEM_PS.enums.NetType.NORMAL then
                temp = net.ReadNormal()
            elseif v[1] == ASEEEM_PS.enums.NetType.STRING then
                temp = net.ReadString()
            elseif v[1] == ASEEEM_PS.enums.NetType.TABLE then
                if v[2] then
                    local bytes = net.ReadUInt(32)
                    temp = util.JSONToTable(util.Decompress(net.ReadData(bytes)))
                else
                    temp = net.ReadTable()
                end
            elseif v[1] == ASEEEM_PS.enums.NetType.UINT then
                temp = net.ReadUInt(v[2])
            elseif v[1] == ASEEEM_PS.enums.NetType.VECTOR then
                temp = net.ReadVector()
            end
            table.insert(data, temp)
        end

        if IsValid(ply) then
            cb(ply, len, data)
            return
        end
        cb(len, data)
    end)
end

function ASEEEM_PS.func.Net(network_string, unreliable, ...)
    unreliable = unreliable or false
    local data = { ... }
    -- data = { { type = ASEEEM_PS.enums.NetType.INT, data = 1234 }, 
    --          { type = ASEEEM_PS.enums.NetType.INT, data = 4567 },
    --          { type = ASEEEM_PS.enums.NetType.COLOR, data = Color(), alpha = true },
    --          { type = ASEEEM_PS.enums.NetType.DATA, data = "", len = 0 },
    --          { type = ASEEEM_PS.enums.NetType.INT, data = "", bit = 0 },
    --          { type = ASEEEM_PS.enums.NetType.TABLE, data = {}, compress = true } }

    net.Start(network_string, unreliable)

    --类型
    local typeData = {}
    for _, v in pairs(data) do
        local i = table.insert(typeData, { v.type })
        
        if v.type == ASEEEM_PS.enums.NetType.COLOR then
            v.alpha = v.alpha or true
            typeData[i][2] = v.alpha
        elseif v.type == ASEEEM_PS.enums.NetType.DATA then
            v.len = v.len or 0
            typeData[i][2] = v.len
        elseif v.type == ASEEEM_PS.enums.NetType.INT or v.type == ASEEEM_PS.enums.NetType.UINT then
            v.bit = v.bit or 32
            typeData[i][2] = v.bit
        elseif v.type == ASEEEM_PS.enums.NetType.TABLE then
            v.compress = v.compress or true
            typeData[i][2] = v.compress
        end
    end
    -- PrintTable(typeData)
    local compressTypeData = util.Compress(util.TableToJSON(typeData))
    net.WriteUInt(#compressTypeData, 32)
    net.WriteData(compressTypeData, #compressTypeData)

    for _, v in pairs(data) do 
        if v.type == ASEEEM_PS.enums.NetType.ANGLE then
            net.WriteAngle(v.data)
        elseif v.type == ASEEEM_PS.enums.NetType.BIT then
            net.WriteBit(v.data)
        elseif v.type == ASEEEM_PS.enums.NetType.BOOL then
            net.WriteBool(v.data)
        elseif v.type == ASEEEM_PS.enums.NetType.COLOR then
            net.WriteColor(v.data, v.alpha or true)
        elseif v.type == ASEEEM_PS.enums.NetType.DATA then
            net.WriteData(v.data, v.len or nil)
        elseif v.type == ASEEEM_PS.enums.NetType.DOUBLE then
            net.WriteDouble(v.data)
        elseif v.type == ASEEEM_PS.enums.NetType.ENTITY then
            net.WriteEntity(v.data)
        elseif v.type == ASEEEM_PS.enums.NetType.FLOAT then
            net.WriteFloat(v.data)
        elseif v.type == ASEEEM_PS.enums.NetType.INT then
            net.WriteInt(v.data, v.bit or 32)
        elseif v.type == ASEEEM_PS.enums.NetType.MATRIX then
            net.WriteMatrix(v.data)
        elseif v.type == ASEEEM_PS.enums.NetType.NORMAL then
            net.WriteNormal(v.data)
        elseif v.type == ASEEEM_PS.enums.NetType.STRING then
            net.WriteString(v.data)
        elseif v.type == ASEEEM_PS.enums.NetType.TABLE then
            v.compress = v.compress or true
            if v.compress then
                local compressData = util.Compress(util.TableToJSON(v.data))
                local bytes = #compressData
                -- print(bytes)
                net.WriteUInt(bytes, 32)
                net.WriteData(compressData, bytes)
            else
                net.WriteTable(v.data)
            end
        elseif v.type == ASEEEM_PS.enums.NetType.UINT then
            net.WriteUInt(v.data, v.bit or 32)
        elseif v.type == ASEEEM_PS.enums.NetType.VECTOR then
            net.WriteVector(v.data)
        end
    end
end

function ASEEEM_PS.func.NetSend(ply)
    net.Send(ply)
end
function ASEEEM_PS.func.NetBroadcast()
    net.Broadcast()
end
function ASEEEM_PS.func.NetServer()
    net.SendToServer()
end
