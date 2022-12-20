util.AddNetworkString("requestInventory")
util.AddNetworkString("inventoryUpdated")
util.AddNetworkString("itemsDataUpdated")

ASEEEM_PS.func.AddHook("PlayerInitialSpawn", "setInventory", function(ply)
    if ply:IsBot() then return end
    --寻找之前该玩家的库存数据，没有就新建
    if !ply:GetInventory() then
        ply:SetInventory({
            steamid = ply:SteamID(),
            point = ASEEEM_PS.config.ASEEEM_PS.config.newPlayerPoint,
            pro_point = ASEEEM_PS.config.newPlayerProPoint,
            inventory = ASEEEM_PS.config.newPlayerInventory
        }, true, true)
        ASEEEM_PS.func.SetNW(ply, 'point', ASEEEM_PS.config.newPlayerPoint)
        ASEEEM_PS.func.SetNW(ply, 'proPoint', ASEEEM_PS.config.newPlayerProPoint)
        return 
    end
    ASEEEM_PS.func.SetNW(ply, 'point', ply:GetPoint())
    ASEEEM_PS.func.SetNW(ply, 'proPoint', ply:GetProPoint())
end)

local plyMeta = FindMetaTable("Player")

function plyMeta:GetInventory()
    local plySteamid = self:SteamID()
    for _, v in pairs(ASEEEM_PS.data.playerInventory) do
        if plySteamid == v.steamid then
            return v
        end
    end
    return nil
end
function plyMeta:SetInventory(inv, save, send_to_player)
    save = save and save or true
    send_to_player = send_to_player and send_to_player or true

    local plySteamid = self:SteamID()
    local plyInv

    for k, v in pairs(ASEEEM_PS.data.playerInventory) do
        -- print(k)
        -- PrintTable(v)
        if plySteamid == v.steamid then
            plyInv = v
            ASEEEM_PS.data.playerInventory[k] = inv
            break
        end
    end

    if !plyInv then
        if next(plyInv) then
            ASEEEM_PS.data.playerInventory[k] = inv
        else
            table.insert(ASEEEM_PS.data.playerInventory, {
                steamid = plySteamid,
                point = inv.point,
                pro_point = inv.pro_point,
                inventory = inv.inventory
            })
        end
    end

    if send_to_player then
        ASEEEM_PS.func.SendInventoryItems(self)
    end

    if save then
        ASEEEM_PS.func.SaveItemData()
    end
end
function plyMeta:GetInventoryItem(index)
    local inv = self:GetInventory()

    if inv then
        return inv.inventory[index]
    end
end
function plyMeta:GetInventoryItemByClass(class)
    local inv = self:GetInventory()

    if inv then
        for _, v in pairs(inv.inventory) do
            if v.class == class then
                return v
            end
        end
    end
    return nil
end
function plyMeta:AddInventoryItem(item, amount, save)
    local playerInv = self:GetInventory()
    if playerInv then
        local playerInvInventory = playerInv.inventory
        amount = amount or 1
        --检查物品是否存在，存在直接加上数量
        for k, v in pairs(playerInvInventory) do
            if v.class == item.class then
                playerInvInventory[k].amount = playerInvInventory[k].amount + amount
                playerInv.inventory = playerInvInventory

                self:SetInventory(playerInv, save)
                return true
            end
        end

        --不存在就加上物品
        --要查看背包是否满了
        if !self:IsInventoryFull() then
            table.insert(playerInvInventory, {
                class = item.class,
                amount = amount,
                is_valid = true,
                equipped = false,
                data = {}
            })
            playerInv.inventory = playerInvInventory
            self:SetInventory(playerInv, save)
            return true
        end
    end
    return false
end
function plyMeta:ReduceInventoryItem(item, amount, save)
    local playerInv = self:GetInventory()
    amount = amount or 1
    if playerInv then
        --检查物品是否存在，存在直接减去
        local playerInvInventory = playerInv.inventory
        for k, v in pairs(playerInvInventory) do
            if v.class == item.class then
                --如果减完之后物品没有了，就删除
                if playerInvInventory[k].amount - amount <= 0 then
                    table.remove(playerInvInventory, k)
                    playerInv.inventory = playerInvInventory

                    self:SetInventory(playerInv, save)
                    return
                end
                playerInvInventory[k].amount = playerInvInventory[k].amount - amount
                playerInv.inventory = playerInvInventory

                self:SetInventory(playerInv, save)
                return 
            end
        end
    end
end
function plyMeta:ModifyInventoryItem(inv_item, key, value, save, send_to_player)
    save = save and save or true
    send_to_player = send_to_player and send_to_player or true

    local playerInv = self:GetInventory()
    if playerInv then
        for k, v in pairs(playerInv.inventory) do
            if v.class == inv_item.class then
                playerInv.inventory[k][key] = value

                self:SetInventory(playerInv, save, send_to_player)
                return true
            end
        end
    end
    return false
end

function plyMeta:IsInventoryFull()
    local itemCount = 0
    for _, v in pairs(self:GetInventory().inventory) do
        if v.is_valid then
            itemCount = itemCount + 1
        end
    end
    if itemCount >= ASEEEM_PS.config.inventorySlots then
        return true
    end
    return false
end

function plyMeta:GetPoint()
    return self:GetInventory().point
end
function plyMeta:GetProPoint()
    return self:GetInventory().pro_point
end
function plyMeta:SetPoint(value, save)
    ASEEEM_PS.func.SetNW(self, 'point', value)

    local plyInv = self:GetInventory()
    if plyInv.point + value <= 0 then
        plyInv.point = 0
    else
        plyInv.point = value
    end
    self:SetInventory(plyInv)

    save = save and false or true
    if save then
        ASEEEM_PS.func.SaveItemData()
    end
end
function plyMeta:SetProPoint(val, save)
    ASEEEM_PS.func.SetNW(self, 'proPoint', val)

    local plyInv = self:GetInventory()
    if plyInv.pro_point + val <= 0 then
        plyInv.pro_point = 0
    else
        plyInv.pro_point = val
    end
    self:SetInventory(plyInv)

    save = save and false or true
    if save then
        ASEEEM_PS.func.SaveItemData()
    end
end
function plyMeta:IncreasePoint(val, save)
    self:SetPoint(self:GetPoint() + val, save)
end
function plyMeta:IncreaseProPoint(val, save)
    self:SetProPoint(self:GetProPoint() + val, save)
end
function plyMeta:DecreasePoint(val, save)
    self:IncreasePoint(0-val, save)
end
function plyMeta:DecreaseProPoint(val, save)
    self:IncreaseProPoint(0-val, save)
end

function ASEEEM_PS.func.SaveItemData()
    --备份
    file.Write("aseeem_pointshop/player_inventory_BKP.json", file.Read("aseeem_pointshop/player_inventory.json", "DATA"))
    --保存
    file.Write("aseeem_pointshop/player_inventory.json", util.TableToJSON(ASEEEM_PS.data.playerInventory, true))
end

function ASEEEM_PS.func.SendInventoryItems(ply)
    ASEEEM_PS.func.Net('inventoryUpdated', false, 
    { type = ASEEEM_PS.enums.NetType.TABLE, data = ply:GetInventory().inventory, compress = true },
    { type = ASEEEM_PS.enums.NetType.INT, data = ASEEEM_PS.config.inventorySlots })

    ASEEEM_PS.func.NetSend(ply)
end

function ASEEEM_PS.func.SendItemTypePlayerData(ply, item_type, item_type_data)
    ASEEEM_PS.func.Net('itemsDataUpdated', false,
    { type = ASEEEM_PS.enums.NetType.STRING, data = item_type },
    { type = ASEEEM_PS.enums.NetType.TABLE, data = item_type_data, compress = true })

    ASEEEM_PS.func.NetSend(ply)
end

ASEEEM_PS.func.NetReceive('requestInventory', ASEEEM_PS.func.SendInventoryItems)