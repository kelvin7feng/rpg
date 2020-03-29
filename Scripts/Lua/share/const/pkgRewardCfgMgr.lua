doNameSpace("pkgRewardCfgMgr")

function GetRewardCfg(dId)
    return _cfg.goodsReward[dId]
end

function GetReward(dId, dTimes)
    local tbReward = {}
    local tbCfg = GetRewardCfg(dId)
    if not tbCfg then
        return tbReward
    end

    dTimes = dTimes or 1
    local dKeyCount = 1
    local strType = "goodsType"
    local strCount = "count"
    local dCount = 0
    while true do

        if not tbCfg[strType..dKeyCount] then
            break
        end

        local dId = tbCfg[strType..dKeyCount]
        local dCount = tbCfg[strCount..dKeyCount]

        if dId > 0 and dCount > 0 then
            table.insert(tbReward, {dId, dCount * dTimes})
        end

        dKeyCount = dKeyCount + 1
    end

    return tbReward
end