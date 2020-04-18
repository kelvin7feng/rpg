doNameSpace("pkgHomeCfgMgr")

ErrorCode = {
    CFG_ILLEGAL             = 1,
    GOODS_NOT_ENOUGH        = 2,
    LEVEL_NOT_ENOUGH        = 3,
    PARAM_ILLEGAL           = 4,
    FORMULA_LOCK            = 5,
    GOODS_ILLEGAL           = 6,
    SCORE_NOT_IN_RANGE      = 7,
    RANDOM_ERROR            = 8,
    EXP_NOT_ENOUGH          = 9,
    LEVEL_UP_SUCCESS        = 10,
    COMPOSE_SUCCESS         = 11,
}

function GetLevelUpCfg(dLevel)
    return _cfg.homeLevelUp[dLevel]
end

function GetLevelUpCost(dLevel)
    local tbCost = {}
    local tbCfg = _cfg.homeLevelUp[dLevel]
    for i=1, 5 do
        local dGoodsType = tbCfg["goodsType"..i]
        local dCount = tbCfg["count"..i]
		if dGoodsType > 0 and dCount > 0 then
            table.insert(tbCost,{dGoodsType, dCount})
        end
    end
    return tbCost
end