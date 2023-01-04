ASEEEM_PS.business = {}

ASEEEM_PS.business.success = nil
ASEEEM_PS.business.error = ''

ASEEEM_PS.func.NetReceive('itemOperation', function(len, data)
    ASEEEM_PS.business.success = data[1]
    if data[2] then
        ASEEEM_PS.business.error = data[2]
    end

    timer.Simple(3, function()
        ASEEEM_PS.business.success = nil 
        ASEEEM_PS.business.error = ''
    end)
end)

ASEEEM_PS.func.NetReceive('clientItemFunc', function(lem, data)
    local itemClass = data[1]
    local run = data[2]
    local first = data[3]

    if first then
        ASEEEM_PS.func.ReadItemTypesData()
    end

    local itemType = ASEEEM_PS.func.GetItemTypeByItemClass(itemClass)

    if itemType and itemType.client and itemType.client[run] then
        return itemType.client[run](ASEEEM_PS.func.GetItemByClass(itemClass), ASEEEM_PS.func.GetInventoryItemByClass(itemClass))
    end
end)

-- 关于PAC的操作
ASEEEM_PS.func.pac = ASEEEM_PS.func.pac or {}


-- function AttachPAC(outfit)
--     if pac then
--         local ply = LocalPlayer()
--         if !ply.AttachPACPart then
--             pac.SetupENT(ply)
--             ply:SetShowPACPartsInEditor( false )
--         end

--         ply:AttachPACPart(outfit, ply)
--     end
-- end

-- timer.Simple(2, function()
    -- print(LocalPlayer():Alive())
    -- while(!ASEEEM_PS.data.inventory or !next(ASEEEM_PS.data.inventory)) 
    --     do
    --         ASEEEM_PS.func.Net('requestInventory')
    --         ASEEEM_PS.func.NetServer()
    --     end
    -- while(!ASEEEM_PS.data.items or !next(ASEEEM_PS.data.items)) 
    --     do
    --         ASEEEM_PS.func.Net('requestItem')
    --         ASEEEM_PS.func.NetServer()
    --     end
    
    -- for _, v in pairs(ASEEEM_PS.data.inventory) do
    --     if v.equipped and v.is_valid then
    --         local item = ASEEEM_PS.func.GetItemByClass(v.class)
    --         local success, error = pcall(ASEEEM_PS.data.itemTypes[item.type].client.on_equip, item, v)
    --         if !success then
    --             MsgC(Color(144, 144, 114), "[Aseeem 点数商店] 在执行物品 " .. v.class .. " 的”on_equip“函数时出错！\n" .. error)
    --         end
    --     end
    -- end
-- end)