if !CAMI then include('autorun/sh_cami.lua') end

CAMI.RegisterPrivilege({
    Name = "Aseeem PointShop Access",
    MinAccess = "admin",
    Description = "Aseeem 点数商店管理面板访问权限。"
})
CAMI.RegisterPrivilege({
    Name = "Aseeem PointShop Point Management",
    MinAccess = "admin",
    Description = "Aseeem 点数商店点数管理。"
})
CAMI.RegisterPrivilege({
    Name = "Aseeem PointShop Items Management",
    MinAccess = "admin",
    Description = "Aseeem 点数商店物品管理。"
})
-- CAMI.RegisterPrivilege({
--     Name = "Aseeem PointShop Player Management",
--     MinAccess = "admin",
--     Description = "Aseeem 点数商店玩家管理。"
-- })