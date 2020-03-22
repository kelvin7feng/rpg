doNameSpace("pkgSysBattle")

m_dCurType = 0
m_dCurLevel = 0
m_dMonsterId = 0

function Init()
    pkgEventManager.Register(CLIENT_EVENT.MONSTER_DEAD, pkgSysBattle.OnMonsterDead)
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

    LOG_DEBUG("OnSpawnMonster ======================== ", dCurType, dCurLevel, dMonsterId)
    if not dCurLevel or dCurLevel <= 0 or not dMonsterId or dMonsterId <= 0 then
        return false
    end
    
    if m_dCurLevel ~= dCurLevel then
        pkgEventManager.PostEvent(CLIENT_EVENT.UPDATE_LEVEL, dCurLevel)
    end

    m_dCurLevel = dCurLevel
    m_dCurType = dCurType
    m_dMonsterId = dMonsterId

    local player = pkgActorManager.GetMainPlayer()
    local spawnPos = pkgSysMonster.GetForwardPos(player, 5)
    local forwardDir = pkgSysPosition.GetForwardDir(player) * - 1
    pkgSysMonster.CreateMonster(dMonsterId, spawnPos, forwardDir)
    
end

function OnMonsterDead(objMonster)
    pkgSocket.SendToLogic(EVENT_ID.CLIENT_BATTLE.KILL_MONSTER, m_dCurLevel, m_dCurType, m_dMonsterId)
end