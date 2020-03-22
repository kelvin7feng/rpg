doNameSpace("pkgLevelCfgMgr")

function GetLevelCfg(dId)
    return _cfg.level[dId]
end

function GetMonsterLibCfg(dLibId)
    return _cfg.monsterLib[dLibId]
end

function GetRandomMonster(dId)
    local tbCfg = GetLevelCfg(dId)
    local dLibId = tbCfg.monsterLibId
    local tbCfgLib = GetMonsterLibCfg(dLibId)
    local dKey = randomKey(tbCfgLib)
    return tbCfgLib["monsterId"..dKey]
end

function GetBossId(dId)
    local tbCfg = GetLevelCfg(dId)
    return tbCfg.boss
end