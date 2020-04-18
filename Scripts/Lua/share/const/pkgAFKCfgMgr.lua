doNameSpace("pkgAFKCfgMgr")

function GetAFKCfg(dLevel)
    return _cfg.afk[dLevel]
end

function CalcScoreLevel(dLevel, dScore)
    local dScoreLevel = nil
    for dTempScoreLevel, tbCfg in pairs(_cfg.afkRandom) do
        if dScore >= tbCfg.minScore and dScore <= tbCfg.maxScore 
            and dLevel >= tbCfg.minLevel and dLevel <= tbCfg.maxLevel then
            dScoreLevel = dTempScoreLevel
            break
        end
    end
    --print("CalcScoreLevel ======================== ", dScoreLevel)
    return dScoreLevel
end

function RandomScoreIndex(dScoreLevelId)
    
    local tbCfgLib = _cfg.afkRandom[dScoreLevelId]
    if not tbCfgLib then
        return nil
    end
    
    local dKey = randomKey(tbCfgLib)
    local dType = nil
    local dLibId = nil
    if dKey then
        dType = tbCfgLib["type" .. dKey]
        if dType == 1 then
            dLibId = tbCfgLib["goodsLib" .. dKey]
        elseif dType == 2 then
            dLibId = tbCfgLib["equipLib" .. dKey]
        end
    end
    --print("RandomScoreIndex ================== ", dType, dLibId)
    return dType, dLibId
end

function RandomGoodsLib(dLibId)
    local tbCfgLib = _cfg.goodsLib[dLibId]
    if not tbCfgLib then
        return nil
    end
    local dKey = randomKey(tbCfgLib)
    local dGoodsId = nil
    if dKey then
        dGoodsId = tbCfgLib["goodsId" .. dKey]
    end
    return dGoodsId
end

function RandomEquipIndex(dLibId)
    local tbCfgLib = _cfg.equipLib[dLibId]
    assert(tbCfgLib)
    local dKey = randomKey(tbCfgLib)
    if dKey then
        return tbCfgLib["equipId" .. dKey]
    end
    return nil
end