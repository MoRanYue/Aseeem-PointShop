include('aps/config.lua')

--自身的文件
if string.lower(ASEEEM_PS.config.whereResource) == 'workshop' then
    resource.AddWorkshop("2266031603")
elseif string.lower(ASEEEM_PS.config.whereResource) == 'server' then
    resource.AddFile('materials/aps/disable.png')
    resource.AddFile('materials/aps/point.png')
    resource.AddFile('materials/aps/pro_point.png')
    resource.AddFile('materials/aps/equipped.png')

    --字体 Fonts
    resource.AddFile("resource/fonts/jiangxizhuokai.ttf")
    resource.AddFile("resource/fonts/deyihei.ttf")
    resource.AddFile("resource/fonts/hanyiwenhei.ttf")
    resource.AddFile("resource/fonts/hanyizhuxinkai.ttf")
    resource.AddFile("resource/fonts/kaiti.ttf")

    resource.AddFile("resource/localization/en/aseeem_ps.properties")
    resource.AddFile("resource/localization/zh-CN/aseeem_ps.properties")
    resource.AddFile("resource/localization/zh-TW/aseeem_ps.properties")

end

if ASEEEM_PS.config.additionalResource then
    --尾迹文件
    resource.AddWorkshop("846689879")
end


AddCSLuaFile('aps/themes/theme.lua')

AddCSLuaFile('aps/cl_business.lua')
AddCSLuaFile('aps/cl_shop.lua')
AddCSLuaFile('aps/cl_inventory.lua')
AddCSLuaFile('aps/cl_data_source.lua')

AddCSLuaFile('aps/vgui/cp_button.lua')
AddCSLuaFile('aps/vgui/cp_header_point.lua')
AddCSLuaFile('aps/vgui/cp_shop_slot.lua')
AddCSLuaFile('aps/vgui/cp_shop_item_info.lua')
AddCSLuaFile('aps/vgui/cp_inventory_item_info.lua')
AddCSLuaFile('aps/vgui/cp_inventory_slot.lua')
AddCSLuaFile('aps/vgui/cp_adjust.lua')

AddCSLuaFile('aps/vgui/p_main.lua')


include('aps/access.lua')
include('aps/business.lua')
include('aps/data_source.lua')
include('aps/shop.lua')
include('aps/inventory.lua')
include('aps/reward.lua')

include('aps/commands.lua')