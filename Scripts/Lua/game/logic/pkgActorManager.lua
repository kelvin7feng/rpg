doNameSpace("pkgActorManager")

m_mainPlayer = m_mainPlayer or nil
m_tbActor = m_tbActor or {}

function CreatePlayer(spawnPosition, spawnRotate)

    local function onLoadComplete(prefab)
        local mainPlayer = Player:new({prefab = prefab, spawnPosition = spawnPosition, spawnRotate = spawnRotate})
        pkgCamera.SetFollowTarget(mainPlayer)
        AddActor(mainPlayer)
        m_mainPlayer = mainPlayer
        pkgMainUI.Init()

        local areaBaker = mainPlayer.gameObject:AddComponent(KG.AgentAreaBaker)
        areaBaker:SetVoxelSize(pkgGlobalConfig.NavMeshSurface.VOXEL_SIZE)
        areaBaker:SetDistanceThreshold(pkgGlobalConfig.NavMeshSurface.DISTANCE_THRESHOLD)
        areaBaker:SetVolumn(pkgGlobalConfig.NavMeshSurface.VOLUME_X,pkgGlobalConfig.NavMeshSurface.VOLUME_Y,pkgGlobalConfig.NavMeshSurface.VOLUME_Z)

        pkgSocket.SendToLogic(EVENT_ID.CLIENT_BATTLE.READY)
    end
    
    pkgAssetBundleMgr.LoadAssetBundle("model", "Hero", onLoadComplete)
end

function GetMainPlayer()
    return m_mainPlayer
end

function AddActor(objActor)
    local dId = objActor:GetId()
    if not m_tbActor[dId] then
        m_tbActor[dId] = objActor
    end
end

function GetActor(dId)
    if not m_tbActor[dId] then
        return nil
    end

    return m_tbActor[dId]
end

function IsAIPlayer(player)
    return player.aiData and true or false
end

function IsMonster(player)
    if player.aiData and player ~= m_mainPlayer then
        return true
    end

    return false
end

function GetAllEnemy(player)
    local tb = {}
    local dPlayerSide = player:GetSide()
    for _, actor in pairs(m_tbActor) do
        if dPlayerSide ~= actor:GetSide() then
            table.insert(tb, actor)
        end
    end

    return tb
end

function GetAllAIPlayer()
    local tb = {}
    for _, actor in pairs(m_tbActor) do
        if IsAIPlayer(actor) then
            table.insert(tb, actor)
        end
    end

    return tb
end

function IsEnemy(player1, player2)
    return player1:GetSide() ~= player2:GetSide() and true or false
end