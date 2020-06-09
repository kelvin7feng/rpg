doNameSpace("pkgSysBattle")

m_dCurType = m_dCurType or 0
m_dCurLevel = m_dCurLevel or 0
m_dMonsterId = m_dMonsterId or 0

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

function OnStart(dErrorCode)
    local player = pkgActorManager.GetMainPlayer()
    pkgSysAI.SetPause(player, false)
end

function OnSpawnMonster(dCurLevel, dCurType, dMonsterId)

    LOG_DEBUG("OnSpawnMonster:", dCurType, dCurLevel, dMonsterId)
    if not dCurLevel or dCurLevel <= 0 or not dMonsterId or dMonsterId <= 0 then
        return false
    end
    
    if m_dCurLevel ~= dCurLevel then
        pkgEventManager.PostEvent(pkgClientEventDefination.UPDATE_BATTLE_LEVEL, dCurLevel)
    end

    local dDefaultDistance = 5
    if dCurType == BATTLE_CHALLENGE_TYPE.BOSS_TYPE then
        Toast(pkgLanguageMgr.GetStringById(1101))
        dDefaultDistance = 15
    end

    m_dCurLevel = dCurLevel
    m_dCurType = dCurType
    m_dMonsterId = dMonsterId

    local player = pkgActorManager.GetMainPlayer()
    local spawnPos = pkgSysMonster.GetForwardPos(player, dDefaultDistance)
    local forwardDir = pkgSysPosition.GetForwardDir(player) * - 1
    pkgSysMonster.CreateMonster(dMonsterId, spawnPos, forwardDir)
    
end

function OnMonsterDead(objMonster)
    pkgSocket.SendToLogic(EVENT_ID.CLIENT_BATTLE.KILL_MONSTER, m_dCurLevel, m_dCurType, m_dMonsterId)
end

function OnUpdateBattleLevel(dNextLevel)
    if not dNextLevel then
        return
    end
    
    pkgUserDataManager.SetBattleLevel(dNextLevel)

    pkgEventManager.PostEvent(pkgClientEventDefination.UPDATE_BATTLE_LEVEL, dNextLevel)
end