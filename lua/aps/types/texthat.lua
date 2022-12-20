local texthat = {}

texthat.class = "texthat"
texthat.display = "文字帽"
texthat.multiple_equip = false
texthat.equipable = true
texthat.color = Color(90, 57, 62)

texthat.items_data = texthat.items_data or {}

-- { 写入玩家自定义物品数据的顺序遵循这里的顺序
--     {
--         name = STRING,
--         type = INT ( CHECKBOX / INPUT / SELECT / VECTOR / COLOR ),
--         validator = FUNCTION,
--         default = ANY
--         select_choice = TABLE ( [ ANY ] = STRING, ... ) | 仅限SELECT类型需要，所有选择的
--     },
--     ...
-- }

texthat.on_buy = function(itm, ply)
end
texthat.on_equip = function(itm, ply, inv_itm)
end
texthat.on_unequip = function(itm, ply, inv_itm)
end
texthat.on_sell = function(itm, ply)
end
texthat.on_adjust = function(itm, ply, inv_itm)
end

texthat.adjust_options = {
    {
        name = '显示文本',
        type = ASEEEM_PS.enums.AdjustType.INPUT,
        validator = function(inp)
            --防止文本过长
            local str = string.Trim(inp)
            return string.sub(str, 1, 25)
        end,
        default = 'Text in Here!'
    },
    {
        name = '彩虹色',
        type = ASEEEM_PS.enums.AdjustType.CHECKBOX,
        validator = function(inp)
            return tobool(inp)
        end,
        default = false
    }
}


ASEEEM_PS.data.itemTypes.texthat = texthat