ASEEEM_PS.reward = ASEEEM_PS.reward or {}

function ASEEEM_PS.reward.Reward()
    for _, v in pairs(player.GetAll()) do
        if !IsValid(v) then
            continue
        end

        local rewarded = false
        for l, w in pairs(ASEEEM_PS.config.rewardPointEveryUserGroups) do
            if v:GetUserGroup() == l then
                v:IncreasePoint(w)
                v:PrintMessage(HUD_PRINTTALK, '[Aseeem 点数商店] 在线时间奖励 点数+' .. tostring(w) .. '。')
                rewarded = true
                break
            end
        end

        if !rewarded then
            v:IncreasePoint(ASEEEM_PS.config.rewardPoint)
            v:PrintMessage(HUD_PRINTTALK, '[Aseeem 点数商店] 在线时间奖励 点数+' .. tostring(ASEEEM_PS.config.rewardPoint) .. '。')
        end
    end
end

function ASEEEM_PS.reward.ProReward()
    for _, v in pairs(player.GetAll()) do
        if !IsValid(v) then
            continue
        end

        local rewarded = false
        for l, w in pairs(ASEEEM_PS.config.rewardProPointEveryUserGroups) do
            if v:GetUserGroup() == l then
                v:IncreasePoint(w)
                v:PrintMessage(HUD_PRINTTALK, '[Aseeem 点数商店] 在线时间奖励 高级点数+' .. tostring(w) .. '。')
                rewarded = true
                break
            end
        end

        if !rewarded then
            v:IncreasePoint(ASEEEM_PS.config.rewardProPoint)
            v:PrintMessage(HUD_PRINTTALK, '[Aseeem 点数商店] 在线时间奖励 高级点数+' .. tostring(ASEEEM_PS.config.rewardProPoint) .. '。')
        end
    end
end

--游玩时间奖励
if ASEEEM_PS.config.rewardForPlaytime > 0 then
    if timer.Exists("ASEEEM_PS_rewardPlaytime") then
        timer.Remove("ASEEEM_PS_rewardPlaytime")
    end
    timer.Create("ASEEEM_PS_rewardPlaytime", ASEEEM_PS.config.rewardForPlaytime*60, 0, ASEEEM_PS.reward.Reward)
end
if ASEEEM_PS.config.proRewardForPlaytime > 0 then
    if timer.Exists("ASEEEM_PS_proRewardPlaytime") then
        timer.Remove("ASEEEM_PS_rewardPlaytime")
    end
    timer.Create("ASEEEM_PS_proRewardPlaytime", ASEEEM_PS.config.proRewardForPlaytime*60, 0, ASEEEM_PS.reward.ProReward)
end