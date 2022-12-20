function ASEEEM_PS.func.GetArgsList(args)
    if isstring(args) then
        return string.Split(args, " ")
    end
    return args
end
function ASEEEM_PS.func.CommandOutput(text, ply)
    timer.Simple(0.2, function()
        local msgs = string.Split(text, '\n')
        msgs[1] = '[Aseeem 点数商店] ' .. msgs[1]

        if IsValid(ply) then
            for _, msg in pairs(msgs) do
                ply:PrintMessage(HUD_PRINTTALK, msg)
            end
        elseif !ply then
            for _, msg in pairs(msgs) do
                PrintMessage(HUD_PRINTTALK, msg)
            end
        end
    end)
end
function ASEEEM_PS.func.CommandPlayerSelector(pattern, searcher)
    if pattern == '*' then
        return player.GetAll()
    elseif pattern == '^' then
        return searcher
    else
        return ASEEEM_PS.func.FindPlayersByRegex(pattern)
    end
end

ASEEEM_PS.commands = ASEEEM_PS.commands or {}

local actions = {
    ['setpoint'] = function(args, sender)
        
        args = ASEEEM_PS.func.GetArgsList(args)
        if !args or !args[2] or !args[3] then return ASEEEM_PS.func.CommandOutput('需要提供参数。', sender) end
        
        ply = ASEEEM_PS.func.CommandPlayerSelector(args[2])
        if istable(ply) then
            players = ''
            for _, v in pairs(ply) do
                players = players .. v:Name() .. '，'
            end
            players = string.TrimRight(players, '，')
            return ASEEEM_PS.func.CommandOutput('找到了多个玩家：' .. players .. '。', sender)
        elseif ply and IsValid(ply) then
            ply:SetPoint(tonumber(args[3]))

            ASEEEM_PS.func.CommandOutput('已把 ' .. ply:Name() .. ' 的点数设置为 ' .. args[2] .. ' 。', sender)
            ASEEEM_PS.func.CommandOutput(sender:Name() .. ' 把 ' .. ply:Name() .. ' 的点数设置为 ' .. args[2] .. ' 。')
            return ASEEEM_PS.func.CommandOutput(sender:Name() .. ' 把你的点数设置为了 ' .. args[2] .. ' 。', ply)
        else
            return ASEEEM_PS.func.CommandOutput('未找到玩家。', sender)
        end
    end,
    ['increasepoint'] = function(args, sender)        
        args = ASEEEM_PS.func.GetArgsList(args)
        -- PrintTable(args)
        if !args or !args[2] or !args[3] then return ASEEEM_PS.func.CommandOutput('需要提供参数。', sender) end
        
        ply = ASEEEM_PS.func.CommandPlayerSelector(args[2])
        print(ply)
        if istable(ply) then
            players = ''
            for _, v in pairs(ply) do
                players = players .. v:Name() .. '，'
            end
            players = string.TrimRight(players, '，')
            return ASEEEM_PS.func.CommandOutput('找到了多个玩家：' .. players .. '。', sender)
        elseif ply and IsValid(ply) then
            ply:IncreasePoint(tonumber(args[3]))

            ASEEEM_PS.func.CommandOutput('已把 ' .. ply:Name() .. ' 的点数增加到 ' .. tostring(ply:GetPoint()) .. ' 。', sender)
            ASEEEM_PS.func.CommandOutput(sender:Name() .. ' 把 ' .. ply:Name() .. ' 的点数增加到 ' .. tostring(ply:GetPoint()) .. ' 。')
            return ASEEEM_PS.func.CommandOutput(sender:Name() .. ' 把你的点数增加到 ' .. tostring(ply:GetPoint()) .. ' 。', ply)
        else
            return ASEEEM_PS.func.CommandOutput('未找到玩家。', sender)
        end
    end,
    ['decreasepoint'] = function(args, sender)
        args = ASEEEM_PS.func.GetArgsList(args)
        if !args or !args[2] or !args[3] then return ASEEEM_PS.func.CommandOutput('需要提供参数。', sender) end
        
        ply = ASEEEM_PS.func.CommandPlayerSelector(args[2])
        if istable(ply) then
            players = ''
            for _, v in pairs(ply) do
                players = players .. v:Name() .. '，'
            end
            players = string.TrimRight(players, '，')
            return ASEEEM_PS.func.CommandOutput('找到了多个玩家：' .. players .. '。', sender)
        elseif ply and IsValid(ply) then
            ply:DecreasePoint(tonumber(args[3]))

            ASEEEM_PS.func.CommandOutput('已把 ' .. ply:Name() .. ' 的点数减少到 ' .. tostring(ply:GetPoint()) .. ' 。', sender)
            ASEEEM_PS.func.CommandOutput(sender:Name() .. ' 把 ' .. ply:Name() .. ' 的点数减少到 ' .. tostring(ply:GetPoint()) .. ' 。')
            return ASEEEM_PS.func.CommandOutput(sender:Name() .. ' 把你的点数减少到 ' .. tostring(ply:GetPoint()) .. ' 。', ply)
        else
            return ASEEEM_PS.func.CommandOutput('未找到玩家。', sender)
        end
    end,

    ['setpropoint'] = function(args, sender)
        
        args = ASEEEM_PS.func.GetArgsList(args)
        if !args or !args[2] or !args[3] then return ASEEEM_PS.func.CommandOutput('需要提供参数。', sender) end
        
        ply = ASEEEM_PS.func.CommandPlayerSelector(args[2])
        if istable(ply) then
            players = ''
            for _, v in pairs(ply) do
                players = players .. v:Name() .. '，'
            end
            players = string.TrimRight(players, '，')
            return ASEEEM_PS.func.CommandOutput('找到了多个玩家：' .. players .. '。', sender)
        elseif ply and IsValid(ply) then
            ply:SetProPoint(tonumber(args[3]))

            ASEEEM_PS.func.CommandOutput('已把 ' .. ply:Name() .. ' 的高级点数设置为 ' .. args[2] .. ' 。', sender)
            ASEEEM_PS.func.CommandOutput(sender:Name() .. ' 把 ' .. ply:Name() .. ' 的高级点数设置为 ' .. args[2] .. ' 。')
            return ASEEEM_PS.func.CommandOutput(sender:Name() .. ' 把你的高级点数设置为了 ' .. args[2] .. ' 。', ply)
        else
            return ASEEEM_PS.func.CommandOutput('未找到玩家。', sender)
        end
    end,
    ['increasepropoint'] = function(args, sender)
        
        args = ASEEEM_PS.func.GetArgsList(args)
        if !args or !args[2] or !args[3] then return ASEEEM_PS.func.CommandOutput('需要提供参数。', sender) end
        
        ply = ASEEEM_PS.func.CommandPlayerSelector(args[2])
        if istable(ply) then
            players = ''
            for _, v in pairs(ply) do
                players = players .. v:Name() .. '，'
            end
            players = string.TrimRight(players, '，')
            return ASEEEM_PS.func.CommandOutput('找到了多个玩家：' .. players .. '。', sender)
        elseif ply and IsValid(ply) then
            ply:IncreaseProPoint(tonumber(args[3]))

            ASEEEM_PS.func.CommandOutput('已把 ' .. ply:Name() .. ' 的高级点数增加到 ' .. tostring(ply:GetProPoint()) .. ' 。', sender)
            ASEEEM_PS.func.CommandOutput(sender:Name() .. ' 把 ' .. ply:Name() .. ' 的高级点数增加到 ' .. tostring(ply:GetProPoint()) .. ' 。')
            return ASEEEM_PS.func.CommandOutput(sender:Name() .. ' 把你的高级点数增加到 ' .. tostring(ply:GetProPoint()) .. ' 。', ply)
        else
            return ASEEEM_PS.func.CommandOutput('未找到玩家。', sender)
        end
    end,
    ['decreasepropoint'] = function(args, sender)
        
        args = ASEEEM_PS.func.GetArgsList(args)
        if !args or !args[2] or !args[3] then return ASEEEM_PS.func.CommandOutput('需要提供参数。', sender) end
        
        ply = ASEEEM_PS.func.CommandPlayerSelector(args[2])
        if istable(ply) then
            players = ''
            for _, v in pairs(ply) do
                players = players .. v:Name() .. '，'
            end
            players = string.TrimRight(players, '，')
            return ASEEEM_PS.func.CommandOutput('找到了多个玩家：' .. players .. '。', sender)
        elseif ply and IsValid(ply) then
            ply:DecreaseProPoint(tonumber(args[3]))

            ASEEEM_PS.func.CommandOutput('已把 ' .. ply:Name() .. ' 的高级点数减少到 ' .. tostring(ply:GetProPoint()) .. ' 。', sender)
            ASEEEM_PS.func.CommandOutput(sender:Name() .. ' 把 ' .. ply:Name() .. ' 的高级点数减少到 ' .. tostring(ply:GetProPoint()) .. ' 。')
            return ASEEEM_PS.func.CommandOutput(sender:Name() .. ' 把你的高级点数减少到 ' .. tostring(ply:GetProPoint()) .. ' 。', ply)
        else
            return ASEEEM_PS.func.CommandOutput('未找到玩家。', sender)
        end
    end
}

local commands = {
    ['aps_help'] = {
        description = '获取所有命令的信息和用法。',
        usage = '没有参数',
        action = function(args, sender)
            msg = '帮助信息\n'

            for cmd, info in pairs(ASEEEM_PS.commands.commands) do
                msg = msg .. ' ' .. cmd .. '\n'
                msg = msg .. '  描述：' .. info.description .. '\n'
                msg = msg .. '   用法：' .. info.usage .. '\n'
            end

            return ASEEEM_PS.func.CommandOutput(msg, sender)
        end
    },

    ['aps_a_setpoint'] = {
        need_access = true,
        need_privilege = 'Aseeem PointShop Point Management',
        description = '设置玩家点数',
        usage = '参数：<玩家名称> <点数>',
        action = actions['setpoint']
    },
    ['aps_a_increasepoint'] = {
        need_access = true,
        need_privilege = 'Aseeem PointShop Point Management',
        description = '增加玩家点数',
        usage = '参数：<玩家名称> <增加点数>',
        action = actions['increasepoint']
    },
    ['aps_a_decreasepoint'] = {
        need_access = true,
        need_privilege = 'Aseeem PointShop Point Management',
        description = '减少玩家点数',
        usage = '参数：<玩家名称> <减少点数>',
        action = actions['decreasepoint']
    },

    ['aps_a_setpropoint'] = {
        need_access = true,
        need_privilege = 'Aseeem PointShop Point Management',
        description = '设置玩家高级点数',
        usage = '参数：<玩家名称> <高级点数>',
        action = actions['setpropoint']
    },
    ['aps_a_increasepropoint'] = {
        need_access = true,
        need_privilege = 'Aseeem PointShop Point Management',
        description = '增加玩家高级点数',
        usage = '参数：<玩家名称> <增加高级点数>',
        action = actions['increasepropoint']
    },
    ['aps_a_decreasepropoint'] = {
        need_access = true,
        need_privilege = 'Aseeem PointShop Point Management',
        description = '减少玩家高级点数',
        usage = '参数：<玩家名称> <减少高级点数>',
        action = actions['decreasepropoint']
    }
}

ASEEEM_PS.commands.actions = actions
ASEEEM_PS.commands.commands = commands

ASEEEM_PS.func.AddHook('PlayerSay', 'Commands', function(ply, text, t_chat)
    local plySaid = string.gsub(string.Trim(string.lower(text)), '^!', '/', 1)
    local command = string.TrimLeft(string.Split(plySaid, ' ')[1], '/')
    local argument = plySaid
    
    --如果没有参数，就设置为nil
    if argument == '' then
        argument = nil
    end
    
    for cmd, info in pairs(commands) do
        if string.lower(cmd) == command then
            if info.need_access then
                CAMI.PlayerHasAccess(ply, 'Aseeem PointShop Access', function(has_access, access_string)
                    if has_access and info.need_privilege then 
                        CAMI.PlayerHasAccess(ply, info.need_privilege, function(has_add_access, access_string)
                            if has_add_access then
                                info.action(argument, ply)
                            else
                                ASEEEM_PS.func.CommandOutput('权限不足，需要权限 ' .. info.need_privilege .. ' 。', sender)
                            end
                        end)
                    elseif has_access then
                        info.action(argument, ply)
                    else 
                        ASEEEM_PS.func.CommandOutput('权限不足，需要权限 Aseeem PointShop Access 。', sender)
                    end
                end)
            else
                info.action(argument, ply)
            end

            break
        end
    end
end)