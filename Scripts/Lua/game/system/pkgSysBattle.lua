doNameSpace("pkgSysBattle")

m_dCurLevel = 0

function GetCurrentLevel()
    return m_dCurLevel
end

function OnStart(dErrorCode)
    local player = pkgActorManager.GetMainPlayer()
    pkgSysAI.SetPause(player, false)
end

function OnSpawnMonster(dCurChalleangeType, dCurLevel)

    LOG_INFO("OnSpawnMonster ======================== ", dCurChalleangeType, dCurLevel)
    if not dCurLevel or dCurLevel <= 0 then
        return false
    end
    
    m_dCurLevel = dCurLevel

    local player = pkgActorManager.GetMainPlayer()
    local spawnPos = pkgSysMonster.GetForwardPos(player, 5)
    local forwardDir = pkgSysPosition.GetForwardDir(player) * -1
    pkgSysMonster.CreateMonster(dCurLevel, spawnPos, forwardDir)
end