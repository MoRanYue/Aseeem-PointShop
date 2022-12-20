-- {
--     name = STRING,
--     description = STRING,
--     class = STRING,
--     type = STRING,
--     show_pic = STRING (MATERIAL PATH) | 优先
--     show_mdl = STRING (MODEL PATH)    | 
--     show_txt = STRING (TEXT)          | 
--     disposable = BOOL,         |
--     equipable = BOOL,          | 
--     adjustable = BOOL,
--     purchasable = BOOL,
--     expires = BOOL / TABLE ( INT(MOUNTH), INT(DAY), INT(HOUR), INT(MINUTE) ) / true -- false表示不会到期，到期时间，true表示已经到期

--     price = INT,
--     pro_price = INT,

--     data = {
--         ... -- 供物品类型文件使用的数据
--     }
-- }

-- on_buy
-- on_equip
-- on_unequip
-- on_sell
-- on_adjust

util.AddNetworkString("itemUpdated")
util.AddNetworkString("requestItem")

function ASEEEM_PS.func.SaveItemData()
    --备份
    file.Write("aseeem_pointshop/items_BKP.json", file.Read("aseeem_pointshop/items.json", "DATA"))
    --保存
    file.Write("aseeem_pointshop/items.json", util.TableToJSON(ASEEEM_PS.data.items, true))
end

function ASEEEM_PS.func.GetItemTypes()
    -- local types = ASEEEM_PS.data.itemTypes -- a
    -- for _, item in pairs(ASEEEM_PS.data.items) do
    --     for _, type in pairs(types) do
    --         if item.type == type.class then

    --         end
    --     end
    -- end
    -- for _, v in pairs(types) do
    --     for _, w in pairs(ASEEEM_PS.data.items) do -- v=a 
    --         if w.type == v.class then
    --             continue 
    --         end
    --         table.insert(types, {
    --             class = w.type,
    --             display = w.type,
    --             purchasable = true,
    --         })
    --     end
    -- end
    local temp = ASEEEM_PS.data.itemTypes
    -- for k, v in pairs(temp) do
    --     v['on_buy'] = nil
    --     v['on_sell'] = nil
    --     v['on_equip'] = nil
    --     v['on_unequip'] = nil
    --     temp[k] = v
    -- end
    return temp
end

function ASEEEM_PS.func.GetItem(class)
    for k, v in pairs(ASEEEM_PS.data.items) do
        if v.class == class then
            return k, v
        end
    end
    return nil
end

function ASEEEM_PS.func.AddItem(item_struct, save)
    table.insert(ASEEEM_PS.data.items, item_struct)
    ASEEEM_PS.func.SendShopItems()

    if save then
        ASEEEM_PS.func.SaveItemData()
    end
end

function ASEEEM_PS.func.RemoveItem(class, save)
    local k, _ = ASEEEM_PS.func.GetItem(class)
    table.remove(ASEEEM_PS.data.items, k)
    ASEEEM_PS.func.SendShopItems()

    if save then
        ASEEEM_PS.func.SaveItemData()
    end
end

function ASEEEM_PS.func.ModifyItem(class, key, value, save)
    save = save and save or true
    for k, v in pairs(ASEEEM_PS.data.items) do
        if v.class == class then
            ASEEEM_PS.data.items[k][key] = value

            if save then
                ASEEEM_PS.func.SaveItemData()
            end
            ASEEEM_PS.func.SendShopItems()

            return true
        end
    end

    return false
end

function ASEEEM_PS.func.AddItemData(class, value, save)
    save = save and save or true
    for k, v in pairs(ASEEEM_PS.data.items) do
        if v.class == class then
            table.insert(ASEEEM_PS.data.items[k].data, value)

            if save then
                ASEEEM_PS.func.SaveItemData()
            end
            ASEEEM_PS.func.SendShopItems()

            return true
        end
    end

    return false
end

function ASEEEM_PS.func.SendShopItems(ply, len)
    ASEEEM_PS.func.Net('itemUpdated', false, 
    { type = ASEEEM_PS.enums.NetType.TABLE, data = ASEEEM_PS.data.items, compress = true },
    { type = ASEEEM_PS.enums.NetType.TABLE, data = ASEEEM_PS.func.GetItemTypes(), compress = true },
    { type = ASEEEM_PS.enums.NetType.FLOAT, data = ASEEEM_PS.config.itemSoldMultiplier },
    { type = ASEEEM_PS.enums.NetType.FLOAT, data = ASEEEM_PS.config.itemPriceMultiplier },
    { type = ASEEEM_PS.enums.NetType.FLOAT, data = ASEEEM_PS.config.itemProPriceMultiplier })

    if ply then
        ASEEEM_PS.func.NetSend(ply)
    else 
        ASEEEM_PS.func.NetBroadcast()
    end
end

ASEEEM_PS.func.NetReceive("requestItem", ASEEEM_PS.func.SendShopItems)