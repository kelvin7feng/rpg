doNameSpace("pkgAchievementCfgMgr")

AchievementType = {
    PLAYER_LEVEL                  = 1,
    USE_FORMULA_TO_COMPOSE        = 2,
}

UnlockType = {
    PLAYER_LEVEL                  = 1,
}

ErrorCode = {
    CFG_ILLEGAL             = 1,
    [1]                     = "smithy_cfg_illegal",
}

le_tbAchievementMap = le_tbAchievementMap or {}
le_tbAchievementUnlockMap = le_tbAchievementUnlockMap or {}

function init()
    for _, dAchievementType in pairs(AchievementType) do
        le_tbAchievementMap[dAchievementType] = dAchievementType
    end

    local dUnlockType = nil
    for dId, tbAchievementCfg in pairs(_cfg.achievement) do
        dUnlockType = tbAchievementCfg.unlockType
        if not le_tbAchievementUnlockMap[dUnlockType] then
            le_tbAchievementUnlockMap[dUnlockType] = {}
        end

        le_tbAchievementUnlockMap[dUnlockType][dId] = tbAchievementCfg
    end
end

init()

function isAchievementDef(dAchievementType)
    if not dAchievementType then
        return false
    end

    return le_tbAchievementMap[dAchievementType] and true or false
end

function getAchievementByUnlockType(dUnlockType)
    return le_tbAchievementUnlockMap[dUnlockType]
end

function getAchievementCfg(dId)
    return _cfg.achievement[dId]
end

function getRewardCfg(dId)
    local tbReward = {}
    local tbCfg = getAchievementCfg(dId)
    for i=1, 5 do
        local dGoodsType = tbCfg["goodsType"..i]
		local dItemId = tbCfg["item"..i]
        local dCount = tbCfg["count"..i]
		if dGoodsType > 0 and dCount > 0 then
            table.insert(tbReward,{dGoodsType, dCount})
        end
    end
    return tbReward
end

function getDefaultAchievement()
    local tbAll = {}
    for _, cfg in pairs(_cfg.achievement) do
        if cfg.default == 1 then
            tbAll[tostring(cfg.achievementType)] = {dType = cfg.achievementType, dId = cfg.id, dProcess = cfg.initProcess}
        end
    end
    
    return tbAll
end