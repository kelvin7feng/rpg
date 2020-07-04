doNameSpace("pkgSysBattle")

m_dCurType = m_dCurType or 0
m_dCurLevel = m_dCurLevel or 0
m_dMonsterId = m_dMonsterId or 0
m_dCreateMonsterCount = m_dCreateMonsterCount or 0
m_dBattleState = 0

function Init()
    pkgEventManager.Register(pkgClientEventDefination.MONSTER_DEAD, pkgSysBattle.OnMonsterDead)
end

function GetCurLevel()
    return m_dCurLevel
end

function GetCurMonsterId()
    return m_dMonsterId
end

function GetCurType()
    return m_dCurType
end

function GetBattleState()
    return m_dBattleState
end

function SetBattleState(dState)
    m_dBattleState = dState
end

function GetCreateMonsterCount()
    return m_dCreateMonsterCount
end

function SetCreateMonsterCount(dCount)
    m_dCreateMonsterCount = dCount or 0
    pkgEventManager.PostEvent(pkgClientEventDefination.ON_CREATE_MONSTER_CHANGED)
end

function OnStart(dErrorCode)
    local player = pkgActorManager.GetMainPlayer()
    pkgSysAI.SetPause(player, false)
    m_dBattleState = pkgBattleConstMgr.BattleState.NORMAL
end

function OnSpawnMonster(dCurLevel, dCurType, dMonsterId)
    
    -- print("OnSpawnMonster:", dCurType, dCurLevel, dMonsterId)
    if not dCurLevel or dCurLevel <= 0 or not dMonsterId or dMonsterId <= 0 then
        return false
    end

    SetCreateMonsterCount(GetCreateMonsterCount()+1)
    if m_dCurLevel ~= dCurLevel then
        pkgEventManager.PostEvent(pkgClientEventDefination.UPDATE_BATTLE_LEVEL, dCurLevel)
    end

    local dDefaultDistance = 10
    if dCurType == BATTLE_CHALLENGE_TYPE.BOSS_TYPE then
        dDefaultDistance = 20
        pkgEventManager.PostEvent(pkgClientEventDefination.ON_BOSS_IS_COMING)
    end

    m_dCurLevel = dCurLevel
    m_dCurType = dCurType
    m_dMonsterId = dMonsterId

    local player = pkgActorManager.GetMainPlayer()
    local spawnPos = pkgSysMonster.GetForwardPos(player, dDefaultDistance)
    local forwardDir = pkgSysPosition.GetForwardDir(player) * - 1
    pkgSysPlayer.FullHp(player)

    -- 小怪增加位置偏移
    if dCurType ~= BATTLE_CHALLENGE_TYPE.BOSS_TYPE then
        local dOffsetZ = math.random(50, 70) / 10 * (math.random(1,100) <= 50 and 1 or -1)
        spawnPos.z = spawnPos.z + dOffsetZ
    end
    
    pkgSysMonster.CreateMonster(dMonsterId, spawnPos, forwardDir)
    
    pkgEventManager.PostEvent(pkgClientEventDefination.ON_SPAWN_MONSTER)
end

function OnMonsterDead(objMonster)
    if m_dCurType == BATTLE_CHALLENGE_TYPE.BOSS_TYPE 
        and pkgBattleLogic.IsBattleWithBoss() then
        SetCreateMonsterCount(0)
        pkgEventManager.PostEvent(pkgClientEventDefination.ON_KILL_BOSS)
        pkgBattleLogic.SetBattleState(pkgBattleConstMgr.BattleState.NORMAL)
    end
    pkgSocket.SendToLogic(EVENT_ID.CLIENT_BATTLE.KILL_MONSTER, m_dCurLevel, m_dCurType, m_dMonsterId)
end

function OnUpdateBattleLevel(dNextLevel)
    if not dNextLevel then
        return
    end
    
    pkgUserDataManager.SetBattleLevel(dNextLevel)

    pkgEventManager.PostEvent(pkgClientEventDefination.UPDATE_BATTLE_LEVEL, dNextLevel)
end