doNameSpace("pkgBattleLogic")

function CanPlayChallengeEffect()
    if pkgBattleLogic.IsNormalState() then
        local dCount = pkgSysBattle.GetCreateMonsterCount()
        if dCount >= 2 then
            return true
        end
    end

    return false
end

function CanChallengeBoss()
    -- 正在挑战时不能再挑战，需要等待打完先
    if pkgSysBattle.GetBattleState() == pkgBattleConstMgr.BattleState.BATTLE_WITH_BOSS then
        return false
    end

    return true
end

function IsNormalState()
    return pkgSysBattle.GetBattleState() == pkgBattleConstMgr.BattleState.NORMAL and true or false
end

function IsBattleWithBoss()
    return pkgSysBattle.GetBattleState() == pkgBattleConstMgr.BattleState.BATTLE_WITH_BOSS and true or false
end

function SetBattleState(dState)
    pkgSysBattle.SetBattleState(dState)
end

function ChallengeBoss()
    
end