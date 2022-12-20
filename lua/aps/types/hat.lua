local hat = {}

hat.class = "hat"
hat.display = "帽子"
hat.multiple_equip = false
hat.equipable = true
hat.color = Color(166, 22, 44)

-- { 写入玩家自定义物品数据的顺序遵循这里的顺序
--     {
--         name = STRING,
--         type = INT ( CHECKBOX / INPUT / SELECT / VECTOR / ANGLE / COLOR ),
--         validator = FUNCTION,
--         default = ANY
--         select_choice = TABLE ( [ ANY ] = STRING, ... ) | 仅限SELECT类型需要，所有选择的
--     },
--     ...
-- }

hat.on_buy = function(item, ply)
end
hat.on_equip = function(item, ply, inv_item)
end
hat.on_unequip = function(item, ply, inv_item)
end
hat.on_sell = function(item, ply)
end
hat.on_adjust = function(item, ply, inv_item)
    -- ply:PrintMessage(HUD_PRINTTALK, ply:Name() .. " 自定义了物品 " .. item.name .. " 的属性为：\n" .. util.TableToJSON(inv_item.data))
end

hat.adjust_options = {
    {
        name = '偏移',
        type = ASEEEM_PS.enums.AdjustType.VECTOR,
        validator = function(x, y, z)
            return Vector(x, y, z)
        end,
        default = Vector(0, 0, 0)
    },
    {
        name = '角度',
        type = ASEEEM_PS.enums.AdjustType.ANGLE,
        validator = function(p, y, r)
            return Angle(p, y, r)
        end,
        default = Angle(0, 0, 0)
    },
    {
        name = '缩放',
        type = ASEEEM_PS.enums.AdjustType.VECTOR,
        validator = function(x, y, z)
            return Vector(x, y, z)
        end,
        default = Vector(0, 0, 0)
    },
    -- {
    --     name = '选择',
    --     type = ASEEEM_PS.enums.AdjustType.SELECT,
    --     validator = function(data)
    --         return ''
    --         -- local x, y, z = vec_table
    --         -- return Vector(math.Clamp(x, 0.8, 1.1), math.Clamp(y, 0.8, 1.1), math.Clamp(z, 0.8, 1.1))
    --     end,
    --     default = 'a',
    --     select_choice = { ['a']='a', ['b']='b' }
    -- },
    -- {
    --     name = '点选',
    --     type = ASEEEM_PS.enums.AdjustType.CHECKBOX,
    --     validator = function(is_checked)
    --         return true
    --     end,
    --     default = true
    -- },
    -- {
    --     name = '颜色',
    --     type = ASEEEM_PS.enums.AdjustType.COLOR,
    --     validator = function(color)
    --         return ''
    --     end,
    --     default = Color(1, 2, 3)
    -- },
    -- {
    --     name = '文本',
    --     type = ASEEEM_PS.enums.AdjustType.INPUT,
    --     validator = function(text)
    --         return text
    --     end,
    --     default = 'a'
    -- },
}

ASEEEM_PS.data.itemTypes.hat = hat