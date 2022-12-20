local weapon = {}

weapon.class = "weapon"
weapon.display = "武器"
weapon.multiple_equip = false
weapon.equipable = true
weapon.color = Color(255, 20, 50)

weapon.items_data = weapon.items_data or {}


weapon.on_buy = function(itm, ply)
end
weapon.on_equip = function(itm, ply, inv_itm)
    ply:Give(itm['data'][1], false)
    ply:SelectWeapon(itm['data'][1])

    ply:ModifyInventoryItem(inv_itm, "equipped", false, true, false)
end
weapon.on_unequip = function(itm, ply, inv_itm)
end
weapon.on_sell = function(itm, ply)
end
weapon.on_adjust = function(itm, ply, inv_itm)
end

-- weapon.adjust_options = {
--     {
--         name = '显示文本',
--         type = ASEEEM_PS.enums.AdjustType.INPUT,
--         validator = function(inp)
--             return string.Trim(inp)
--         end,
--         default = 'Text in Here!'
--     },
--     {
--         name = '彩虹色',
--         type = ASEEEM_PS.enums.AdjustType.CHECKBOX,
--         validator = function(inp)
--             return tobool(inp)
--         end,
--         default = false
--     }
-- }


ASEEEM_PS.data.itemTypes.weapon = weapon