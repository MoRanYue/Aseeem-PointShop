include('aps/themes/theme.lua')

include('aps/cl_business.lua')
include('aps/cl_shop.lua')
include('aps/cl_inventory.lua')
include('aps/cl_data_source.lua')

include('aps/vgui/cp_button.lua')
include('aps/vgui/cp_header_point.lua')
include('aps/vgui/cp_shop_slot.lua')
include('aps/vgui/cp_shop_item_info.lua')
include('aps/vgui/cp_inventory_item_info.lua')
include('aps/vgui/cp_inventory_slot.lua')
include('aps/vgui/cp_adjust.lua')

include('aps/vgui/p_main.lua')

-- function ASEEEM_PS.func.ReadItemTypesData()
--     ASEEEM_PS.data.itemTypes = {}
--     local files, _ = file.Find('aps/types/*.lua', "LUA")
--     for _, v in pairs(files) do
--         include('aps/types/' .. v)
--     end

--     for k, v in pairs(ASEEEM_PS.data.itemTypes) do
--         ASEEEM_PS.data.itemTypes[k].on_buy = nil
--         ASEEEM_PS.data.itemTypes[k].on_equip = nil
--         ASEEEM_PS.data.itemTypes[k].on_unequip = nil
--         ASEEEM_PS.data.itemTypes[k].on_sell = nil
--         ASEEEM_PS.data.itemTypes[k].on_adjust = nil
--         ASEEEM_PS.data.itemTypes[k].items_data = nil
--         ASEEEM_PS.data.itemTypes[k].class = nil
--         ASEEEM_PS.data.itemTypes[k].display = nil
--         ASEEEM_PS.data.itemTypes[k].multiple_equip = nil
--         ASEEEM_PS.data.itemTypes[k].equipable = nil
--         ASEEEM_PS.data.itemTypes[k].color = nil
--         ASEEEM_PS.data.itemTypes[k].adjust_options = nil
--     end
-- end

-- timer.Simple(1, ASEEEM_PS.func.ReadItemTypesData)

chat.AddText(Color(200, 0, 244), '[Aseeem 点数商店] ', Color(244, 244, 244), '欢迎使用点数商店，若要使用，请按下O键或F3键。')