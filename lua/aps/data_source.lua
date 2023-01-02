if !file.IsDir("aseeem_pointshop", "DATA") then
    file.CreateDir('aseeem_pointshop')
end

-- {
--     steamid = STRING,
--     inventory = {
--         {
--             class = STRING,
--             amount = INT,
--             is_valid = BOOL, --需要检查是否是已存在的物品。
--             equipped = BOOL -- 需要检查是否是可装备可使用的物品
--             data = TABLE -- 用于可以让玩家自定义属性的物品
--         }
--         ...
--     },
--     point = INT,
--     pro_point = INT
-- }

if !file.Exists("aseeem_pointshop/player_inventory.json", "DATA") then
    file.Write("aseeem_pointshop/player_inventory.json", '[]')
end
if !file.Exists("aseeem_pointshop/items.json", "DATA") then
    file.Write("aseeem_pointshop/items.json", '[{"expires":false,"equipable":true,"class":"electric_trail","show_pic":"trails/electric.vmt","pro_price":700,"name":"雷电","adjustable":false,"data":[{"r":14,"g":13,"b":254,"a":255},13,0,5,"trails/electric.vmt"],"disposable":false,"type":"trail","price":1200,"purchasable":true,"description":"雷电尾迹"},{"expires":false,"equipable":true,"class":"laser_trail","show_pic":"trails/laser.vmt","pro_price":500,"name":"激光","adjustable":false,"data":[{"r":255,"g":0,"b":254,"a":255},10,0,5,"trails/laser.vmt"],"disposable":false,"type":"trail","price":1000,"purchasable":true,"description":"激光尾迹"},{"expires":false,"equipable":true,"class":"lol_trail","show_pic":"trails/lol.vmt","pro_price":730,"name":"LOL","adjustable":false,"data":[{"r":255,"g":244,"b":254,"a":255},10,3,6,"trails/lol.vmt"],"disposable":false,"type":"trail","price":1100,"purchasable":true,"description":"LOL"},{"expires":false,"equipable":true,"class":"love_trail","show_pic":"trails/love.vmt","pro_price":730,"name":"爱心","adjustable":false,"data":[{"r":255,"g":255,"b":255,"a":255},14,0,9,"trails/love.vmt"],"disposable":false,"type":"trail","price":1040,"purchasable":true,"description":"爱心尾迹"},{"expires":false,"equipable":true,"class":"plasma_trail","show_pic":"trails/plasma.vmt","pro_price":800,"name":"等离子","adjustable":false,"data":[{"r":255,"g":200,"b":255,"a":255},13,0,8,"trails/plasma.vmt"],"disposable":false,"type":"trail","price":1040,"purchasable":true,"description":"等离子尾迹"},{"expires":false,"equipable":true,"class":"smoke_trail","show_pic":"trails/smoke.vmt","pro_price":600,"name":"烟雾","adjustable":false,"data":[{"r":177,"g":255,"b":133,"a":255},13,0,8,"trails/smoke.vmt"],"disposable":false,"type":"trail","price":1040,"purchasable":true,"description":"烟雾尾迹"},{"expires":false,"equipable":true,"class":"tube_trail","show_pic":"trails/tube.vmt","pro_price":888,"name":"管道","adjustable":false,"data":[{"r":255,"g":255,"b":255,"a":255},15,1,5,"trails/tube.vmt"],"disposable":false,"type":"trail","price":1300,"purchasable":true,"description":"管道尾迹"},{"expires":false,"equipable":true,"class":"portal_trail","show_pic":"trails/portal.vmt","pro_price":400,"name":"传送门","adjustable":false,"data":[{"r":180,"g":255,"b":255,"a":255},17,5,8,"trails/portal.vmt"],"disposable":false,"type":"trail","price":900,"purchasable":true,"description":"传送门尾迹"}]')
end

function ASEEEM_PS.func.ReadItemsData()
    ASEEEM_PS.data.items = util.JSONToTable(file.Read("aseeem_pointshop/items.json", "DATA"))
    if !ASEEEM_PS.data.items then
        MsgC(Color(23, 23, 255), "[Aseeem Pointshop] 错误：物品文件格式错误！读取失败。")
        return
    end
    ASEEEM_PS.func.ReadPlayerInvData()
end
function ASEEEM_PS.func.ReadClientItemTypesData()
    local files, _ = file.Find('aps/types/client/*.lua', "LUA")
    for _, v in pairs(files) do
        AddCSLuaFile('aps/types/client/' .. v)
    end
end
function ASEEEM_PS.func.ReadItemTypesData()
    ASEEEM_PS.data.itemTypes = {}
    local files, _ = file.Find('aps/types/*.lua', "LUA")
    for _, v in pairs(files) do
        AddCSLuaFile('aps/types/' .. v)
        include('aps/types/' .. v)
    end
end
function ASEEEM_PS.func.ReadPlayerInvData()
    ASEEEM_PS.data.playerInventory = util.JSONToTable(file.Read("aseeem_pointshop/player_inventory.json", "DATA"))
    if !ASEEEM_PS.data.playerInventory then
        MsgC(Color(100, 25, 255), "[Aseeem Pointshop] 错误：玩家库存文件格式错误！读取失败。")
        return 
    end

    for k, v in pairs(ASEEEM_PS.data.playerInventory) do
        for l, w in pairs(v.inventory) do
            local isValid = false
            for _, x in pairs(ASEEEM_PS.data.items) do
                if x.class == w.class then
                    isValid = true
                    break
                end
            end
            if isValid then
                ASEEEM_PS.data.playerInventory[k].inventory[l].is_valid = true
            else
                ASEEEM_PS.data.playerInventory[k].inventory[l].is_valid = false
            end
        end
    end
end

ASEEEM_PS.func.ReadClientItemTypesData()
ASEEEM_PS.func.ReadItemTypesData()
ASEEEM_PS.func.ReadItemsData()
ASEEEM_PS.func.ReadPlayerInvData()

concommand.Add("aseeem_ps_refresh_items", ASEEEM_PS.func.ReadItemsData)
concommand.Add("aseeem_ps_refresh_item_types", ASEEEM_PS.func.ReadItemTypesData)
concommand.Add('aseeem_ps_refresh_player_inventory', ASEEEM_PS.func.ReadPlayerInvData)
concommand.Add('aseeem_ps_refresh_data', function()
    ASEEEM_PS.func.ReadItemTypesData()
    ASEEEM_PS.func.ReadItemsData()
    ASEEEM_PS.func.ReadPlayerInvData()
end)

-- if ASEEEM_PS.config.checkingFilesTimer then
--     if timer.Exists('Aseeem_PS_checkFiles') then
--         timer.Remove('Aseeem_PS_checkFiles')
--     end

--     timer.Create('Aseeem_PS_checkFiles', ASEEEM_PS.config.checkingFilesTimer, 0, function()
--         print('[Aseeem Pointshop] 检测到玩家库存文件更新。')
--         local playerInventory = util.JSONToTable(file.Read("aseeem_pointshop/player_inventory.json", "DATA"))
--         local items = util.JSONToTable(file.Read("aseeem_pointshop/items.json", "DATA"))
--         if !playerInventory then
--             MsgC(Color(23, 23, 255), "[Aseeem Pointshop] 错误：玩家库存文件格式错误！读取失败。")
--             return
--         end
--         if !items then
--             MsgC(Color(23, 23, 255), "[Aseeem Pointshop] 错误：物品文件格式错误！读取失败。")
--             return
--         end

--         if !ASEEEM_PS.func.TablesAreEqual(items, ASEEEM_PS.data.items) then
--             MsgC(Color(255, 128, 0), "[Aseeem Pointshop] 检测到物品文件更新。")

--             ASEEEM_PS.data.items = items
--         end

--         if ASEEEM_PS.func.TablesAreEqual(playerInventory, ASEEEM_PS.data.playerInventory) then 
--             MsgC(Color(255, 128, 0), "[Aseeem Pointshop] 检测到玩家库存文件更新。")

--             ASEEEM_PS.data.playerInventory = playerInventory

--             for k, v in pairs(ASEEEM_PS.data.playerInventory) do
--                 for l, w in pairs(v.inventory) do
--                     local isValid = false
--                     for _, x in pairs(ASEEEM_PS.data.items) do
--                         if x.class == w.class then
--                             isValid = true
--                             break
--                         end
--                     end
--                     if isValid then
--                         ASEEEM_PS.data.playerInventory[k].inventory[l].is_valid = true
--                     else
--                         ASEEEM_PS.data.playerInventory[k].inventory[l].is_valid = false
--                     end
--                 end
--             end
--         end
--     end)
-- end