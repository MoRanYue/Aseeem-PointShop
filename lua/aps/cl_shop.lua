ASEEEM_PS.data.items = ASEEEM_PS.data.items or {}
ASEEEM_PS.data.itemTypes = ASEEEM_PS.data.itemTypes or {}

ASEEEM_PS.func.NetReceive('itemUpdated', function(len, data)
    ASEEEM_PS.data.items = data[1]
    ASEEEM_PS.data.itemTypes = data[2]
    ASEEEM_PS.func.ReadItemTypesData()
    ASEEEM_PS.data.itemSoldMultiplier = data[3]
    ASEEEM_PS.data.itemPriceMultiplier = data[4]
    ASEEEM_PS.data.itemProPriceMultiplier = data[5]
end)

function ASEEEM_PS.func.GetItemsInItemType(type)
    local foundItems = {}
    for k, v in pairs(ASEEEM_PS.data.items) do
        if v.type == type.class then
            table.insert(foundItems, v)
        end
    end
    return foundItems
end

function ASEEEM_PS.func.GetItemTypeByItemClass(item_class)
    for k, v in pairs(ASEEEM_PS.data.itemTypes) do
        if !ASEEEM_PS.func.GetItemByClass(item_class) then return nil end
        if ASEEEM_PS.func.GetItemByClass(item_class).type == k then
            return v
        end
    end
    return nil
end
function ASEEEM_PS.func.GetItemTypeByItem(item)
    return ASEEEM_PS.data.itemTypes[item.type]
end

if !ASEEEM_PS.data.items or !next(ASEEEM_PS.data.items) then
    ASEEEM_PS.func.Net('requestItem')
    ASEEEM_PS.func.NetServer()
end

function ASEEEM_PS.func.RequestItems()
    ASEEEM_PS.func.Net('requestItem')
    ASEEEM_PS.func.NetServer()
    ASEEEM_PS.func.ReadItemTypesData()
end

concommand.Add("aseeem_ps_refresh_items", ASEEEM_PS.func.RequestItems)