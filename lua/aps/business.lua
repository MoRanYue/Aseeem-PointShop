util.AddNetworkString("itemOperation") --带操作指令，有的需要管理员权限
util.AddNetworkString("clientItemFunc")

--返回给玩家的信息 = 
-- {
--     success = BOOL
-- }
--如果没有成功 = 
-- {
--     success = BOOL,
--     error = STRING 错误信息
-- }

ASEEEM_PS.func.AddCHook('PlayerFullyConnectedBussiness', 'setupEquippedItems', function(ply)
    local plyInv = ply:GetInventory()
    if plyInv then
        local plyInvInventory = plyInv.inventory
        for _, v in pairs(plyInv.inventory) do
            if v.is_valid and v.equipped then
                local _, item = ASEEEM_PS.func.GetItem(v.class)
                local success, error = pcall(ASEEEM_PS.data.itemTypes[item.type].on_equip, item, ply, v)
                if !success then
                    MsgC(Color(144, 144, 114), "[Aseeem 点数商店] 玩家 " .. ply:Name() .. "（" .. ply:SteamID() .. "）" .. " 在执行物品 " .. v.name .. "（" .. v.class .. "） 的”on_equip“函数时出错！\n" .. error)
                end

                timer.Simple(5, function() --需要运行客户端需要运行的“on_equip”函数
                    ASEEEM_PS.func.Net('clientItemFunc', false, 
                                { type = ASEEEM_PS.enums.NetType.STRING, data = item.class }, 
                                { type = ASEEEM_PS.enums.NetType.STRING, data = 'on_equip' },
                                { type = ASEEEM_PS.enums.NetType.BOOL, data = true })
                    ASEEEM_PS.func.NetSend(ply)
                end)
            end
        end
    end
end)
ASEEEM_PS.func.AddHook("PlayerInitialSpawn", "setupInventory", function(ply)
    --因为这个钩子调用时玩家并没有完全进入游戏，解决这个问题
    ASEEEM_PS.func.AddHook('SetupMove', ply, function(s, pl, _, cmd)
        if s == pl and !cmd:IsForced() then
            ASEEEM_PS.func.RunCHook('PlayerFullyConnectedBussiness', s)
            ASEEEM_PS.func.RemoveHook('SetupMove', s) --删除这个钩子
        end
    end)
end)

ASEEEM_PS.func.NetReceive('itemOperation', function(ply, len, data)
    local opType = data[1]
    local opData = data[2]
    
    if opType == ASEEEM_PS.enums.ItemOperation.BUY then
        --获取物品，检测玩家背包有没有满，添加到玩家背包，扣除点数，把背包数据发给玩家。
        local _, item = ASEEEM_PS.func.GetItem(opData[2])
        if item and item.purchasable and !ply:IsInventoryFull() then
            if opData[1] == ASEEEM_PS.enums.PointType.POINT and ply:GetPoint() >= item.price then --货币种类
                ply:AddInventoryItem(item)
                ply:DecreasePoint(item.price*ASEEEM_PS.config.itemPriceMultiplier)
                --运行代码
                ASEEEM_PS.data.itemTypes[item.type].on_buy(item, ply)
                ASEEEM_PS.func.Net('itemOperation', false, { type = ASEEEM_PS.enums.NetType.BOOL, data = true })
                ASEEEM_PS.func.NetSend(ply)
                ASEEEM_PS.func.SendInventoryItems(ply)
            elseif opData[1] == ASEEEM_PS.enums.PointType.PROPOINT and ply:GetProPoint() >= item.pro_price then
                ply:AddInventoryItem(item)
                ply:DecreaseProPoint(item.pro_price*ASEEEM_PS.config.itemProPriceMultiplier)
                ASEEEM_PS.data.itemTypes[item.type].on_buy(item, ply)
                ASEEEM_PS.func.Net('itemOperation', false, { type = ASEEEM_PS.enums.NetType.BOOL, data = true })
                ASEEEM_PS.func.NetSend(ply)
                ASEEEM_PS.func.SendInventoryItems(ply)
            else
                ASEEEM_PS.func.Net('itemOperation', false, 
                    { type = ASEEEM_PS.enums.NetType.BOOL, data = false }, 
                    { type = ASEEEM_PS.enums.NetType.STRING, data = '买不起这件物品' })
                ASEEEM_PS.func.NetSend(ply)
            end
        else
            ASEEEM_PS.func.Net('itemOperation', false, 
                    { type = ASEEEM_PS.enums.NetType.BOOL, data = false },
                    { type = ASEEEM_PS.enums.NetType.STRING, data = '背包已满、物品不可购买或物品不存在' })
            ASEEEM_PS.func.NetSend(ply)
        end
    elseif opType == ASEEEM_PS.enums.ItemOperation.SELL then
        --获取物品，检测物品是否还有，加点数，把背包数据发给玩家。
        local item = ply:GetInventoryItemByClass(opData[1])
        local _, itm = ASEEEM_PS.func.GetItem(opData[1])
        if item and item.is_valid and !item.equipped then
            ply:ReduceInventoryItem(item)
            ply:IncreasePoint(math.floor(itm.price*ASEEEM_PS.config.itemSoldMultiplier))
            ASEEEM_PS.data.itemTypes[itm.type].on_sell(itm, ply)
            ASEEEM_PS.func.Net('itemOperation', false, 
                { type = ASEEEM_PS.enums.NetType.BOOL, data = true })
            ASEEEM_PS.func.NetSend(ply)
            ASEEEM_PS.func.SendInventoryItems(ply)
        else
            ASEEEM_PS.func.Net('itemOperation', false, 
                    { type = ASEEEM_PS.enums.NetType.BOOL, data = false },
                    { type = ASEEEM_PS.enums.NetType.STRING, data = '需要先取消装备物品或该物品不存在' })
            ASEEEM_PS.func.NetSend(ply)
        end
    elseif opType == ASEEEM_PS.enums.ItemOperation.EQUIP then
        --获取物品，检测物品是否还有，物品是否是一次性的，物品是否可装备，该类型是否可多件装备，物品是否已装备，运行物品在装备时的脚本，修改玩家背包数据，把背包数据发给玩家。
        local item = ply:GetInventoryItemByClass(opData[1])
        local _, itm = ASEEEM_PS.func.GetItem(opData[1])
        if item and item.is_valid and itm.equipable and !item.equipped then
            if ASEEEM_PS.data.itemTypes[itm.type].multiple_equip then
                ply:ModifyInventoryItem(item, 'equipped', true)
            else
                for _, v in pairs(ply:GetInventory().inventory) do
                    if v.is_valid then
                        local _, it = ASEEEM_PS.func.GetItem(v.class)
                        if it and itm.type == it.type and v.equipped then
                            ply:ModifyInventoryItem(v, 'equipped', false)
                            ASEEEM_PS.data.itemTypes[it.type].on_unequip(itm, ply)
                        end
                    end
                end
                ply:ModifyInventoryItem(item, 'equipped', true)
            end

            ASEEEM_PS.data.itemTypes[itm.type].on_equip(itm, ply, ply:GetInventoryItemByClass(opData[1]))
            if itm.disposable then
                ply:ReduceInventoryItem(item)
            end

            ASEEEM_PS.func.Net('itemOperation', false, 
                { type = ASEEEM_PS.enums.NetType.BOOL, data = true })
            ASEEEM_PS.func.NetSend(ply)
            ASEEEM_PS.func.SendInventoryItems(ply)
        else
            ASEEEM_PS.func.Net('itemOperation', false, 
                    { type = ASEEEM_PS.enums.NetType.BOOL, data = false },
                    { type = ASEEEM_PS.enums.NetType.STRING, data = '该物品是不可装备、已装备或不存在' })
            ASEEEM_PS.func.NetSend(ply)
        end
    elseif opType == ASEEEM_PS.enums.ItemOperation.UNEQUIP then
        --获取物品，检测物品是否还有，物品是否是一次性的，物品是否可装备，物品是否已装备，运行物品在取消装备时的脚本，修改玩家背包数据，把背包数据发给玩家。
        local item = ply:GetInventoryItemByClass(opData[1])
        local _, itm = ASEEEM_PS.func.GetItem(item.class)
        if item and item.is_valid and itm.equipable and !itm.disposable and item.equipped then
            ply:ModifyInventoryItem(item, 'equipped', false)
            ASEEEM_PS.data.itemTypes[itm.type].on_unequip(itm, ply, ply:GetInventoryItemByClass(opData[1]))
            ASEEEM_PS.func.Net('itemOperation', false, 
                { type = ASEEEM_PS.enums.NetType.BOOL, data = true })
            ASEEEM_PS.func.NetSend(ply)
            ASEEEM_PS.func.SendInventoryItems(ply)
        else
            ASEEEM_PS.func.Net('itemOperation', false, 
                    { type = ASEEEM_PS.enums.NetType.BOOL, data = false },
                    { type = ASEEEM_PS.enums.NetType.STRING, data = '该物品是一次性的、不可装备、未装备或不存在' })
            ASEEEM_PS.func.NetSend(ply)
        end
    elseif opType == ASEEEM_PS.enums.ItemOperation.ADJUST then
        --获取物品，检测物品是否还有，物品是否已装备，物品是否可设置，修改玩家背包物品数据，把背包数据发给玩家。
        local item = ply:GetInventoryItemByClass(opData[1])
        local _, itm = ASEEEM_PS.func.GetItem(item.class)
        if item and item.is_valid and !item.equipped then
            if itm and itm.adjustable then
                --调用验证函数
                local adjustData = opData[2]
                local validatedData = {}
                for k, v in pairs(ASEEEM_PS.data.itemTypes[itm.type].adjust_options) do
                    local temp = v.validator(adjustData[k])
                    table.insert(validatedData, temp)
                end
                ply:ModifyInventoryItem(item, 'data', validatedData, true)
                ASEEEM_PS.data.itemTypes[itm.type].on_adjust(itm, ply, ply:GetInventoryItemByClass(opData[1]))

                ASEEEM_PS.func.Net('itemOperation', false, 
                    { type = ASEEEM_PS.enums.NetType.BOOL, data = true })
                ASEEEM_PS.func.NetSend(ply)
            else
                ASEEEM_PS.func.Net('itemOperation', false, 
                    { type = ASEEEM_PS.enums.NetType.BOOL, data = false },
                    { type = ASEEEM_PS.enums.NetType.STRING, data = '该物品不可自定义' })
                ASEEEM_PS.func.NetSend(ply)
            end
        else
            ASEEEM_PS.func.Net('itemOperation', false, 
                    { type = ASEEEM_PS.enums.NetType.BOOL, data = false },
                    { type = ASEEEM_PS.enums.NetType.STRING, data = '需要先取消装备物品' })
            ASEEEM_PS.func.NetSend(ply)
        end
    elseif opType == ASEEEM_PS.enums.ItemOperation.POINTTRANSFER then
        --检测玩家是否在服务器内，点数是否足够，修改两个玩家背包数据，把背包数据发给玩家
        local tranferPoint = opData[2]
        local target = (opData[3])
        if !IsValid(target) then
            ASEEEM_PS.func.Net('itemOperation', false, 
                { type = ASEEEM_PS.enums.NetType.BOOL, data = false }, 
                { type = ASEEEM_PS.enums.NetType.STRING, data = '玩家不在服务器内' })
            ASEEEM_PS.func.NetSend(ply)
        end
        if opData[1] == ASEEEM_PS.enums.PointType.POINT and ply:GetPoint() >= tranferPoint then
            ply:DecreasePoint(tranferPoint)
            target:IncreasePoint(tranferPoint)
            ASEEEM_PS.func.Net('itemOperation', false, { type = ASEEEM_PS.enums.NetType.BOOL, data = true })
            ASEEEM_PS.func.NetSend(ply)
        elseif opData[1] == ASEEEM_PS.enums.PointType.PROPOINT and ply:GetProPoint() >= tranferPoint then
            ply:DecreaseProPoint(tranferPoint)
            target:IncreaseProPoint(tranferPoint)
            ASEEEM_PS.func.Net('itemOperation', false, { type = ASEEEM_PS.enums.NetType.BOOL, data = true })
            ASEEEM_PS.func.NetSend(ply)
        else
            ASEEEM_PS.func.Net('itemOperation', false, 
                { type = ASEEEM_PS.enums.NetType.BOOL, data = false }, 
                { type = ASEEEM_PS.enums.NetType.STRING, data = '点数不够' })
            ASEEEM_PS.func.NetSend(ply)
        end
    end
end)