ASEEEM_PS.data.inventory = ASEEEM_PS.data.inventory or {}

ASEEEM_PS.func.NetReceive('inventoryUpdated', function(len, data)
    ASEEEM_PS.data.inventory = data[1]
    ASEEEM_PS.data.invSlots = data[2]
end)
ASEEEM_PS.func.NetReceive('itemsDataUpdated', function(len, data)
    local itemType = data[1]
    local itemData = data[2]
    ASEEEM_PS.data.itemTypes[itemType].items_data = itemData
end)

if ASEEEM_PS.data.inventory then
    ASEEEM_PS.func.Net('requestInventory')
    ASEEEM_PS.func.NetServer()
end

-- function ASEEEM_PS.func.GetInventoryItem(index)
--     local inv = self:GetInventory()

--     if inv then
--         return inv.inventory[index]
--     end
-- end
function ASEEEM_PS.func.GetInventoryItemByClass(class)
    for _, v in pairs(ASEEEM_PS.data.inventory) do
        if v.class == class then
            return v
        end
    end
    return nil
end
function ASEEEM_PS.func.GetItemByClass(class)
    for _, v in pairs(ASEEEM_PS.data.items) do
        if class == v.class then
            return v
        end
    end
end
function ASEEEM_PS.func.GetItemFromInventoryItem(inv_item)
    for _, v in pairs(ASEEEM_PS.data.items) do
        if inv_item.class == v.class then
            return v
        end
    end
    return nil
end

function ASEEEM_PS.func.GetPoint()
    return ASEEEM_PS.func.GetNW(LocalPlayer(), 'point')
end
function ASEEEM_PS.func.GetProPoint()
    return ASEEEM_PS.func.GetNW(LocalPlayer(), 'proPoint')
end

function ASEEEM_PS.func.RequestInventory()
    ASEEEM_PS.func.Net('requestInventory')
    ASEEEM_PS.func.NetServer()
end



concommand.Add("aseeem_ps_refresh_inventory", ASEEEM_PS.func.RequestInventory)