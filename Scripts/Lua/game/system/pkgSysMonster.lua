doNameSpace("pkgSysMonster")

function StartBehaviour(monster)
    local behaviourTreeOwner = nil
    if monster.aiData.behaviourTreeOwner then
        behaviourTreeOwner = monster.aiData.behaviourTreeOwner
    else
        behaviourTreeOwner = monster.gameObject:GetComponent(NodeCanvas.BehaviourTrees.BehaviourTreeOwner)
    end

    if behaviourTreeOwner then
        behaviourTreeOwner:StartBehaviour()
    end
end

function StopBehaviour(monster)
    local behaviourTreeOwner = nil
    if monster.aiData.behaviourTreeOwner then
        behaviourTreeOwner = monster.aiData.behaviourTreeOwner
    else
        behaviourTreeOwner = monster.gameObject:GetComponent(NodeCanvas.BehaviourTrees.BehaviourTreeOwner)
    end

    if behaviourTreeOwner then
        behaviourTreeOwner:StopBehaviour(true)
    end
end

function InitBehaviourTree(monster)
    local tbConfig = _cfg.monster[monster.aiData.dMonsterId]
    local strAssetBundleName = tbConfig[pkgConfigFieldDefination.Monster.AI_ASSET_BUNDLE_NAME]
    local strAssetName = tbConfig[pkgConfigFieldDefination.Monster.AI_ASSET_NAME]
    if not strAssetBundleName or not strAssetName then
        LOG_DEBUG("BehaviourTree config is nil")
        return
    end

    local behaviourTreeOwner = monster.gameObject:AddComponent(NodeCanvas.BehaviourTrees.BehaviourTreeOwner)
    monster.aiData.behaviourTreeOwner = behaviourTreeOwner

    local function onLoadComplete(prefab)
        if not prefab then
            LOG_ERROR("graph prefab is nil..." .. strAssetBundleName .. ", " .. strAssetName)
            return
        end
        local graph = UnityEngine.GameObject.Instantiate(prefab)
        monster.aiData.behaviourTreeOwner.graph = graph
        StartBehaviour(monster)
    end

    pkgAssetBundleMgr.LoadAssetBundle(strAssetBundleName, strAssetName, onLoadComplete)
end

function CreateMonster(dMonsterId, spawnPosition, spawnRotate)

    local function onLoadComplete(prefab)
        local monster = Monster:new({dMonsterId = dMonsterId, prefab = prefab, spawnPosition = spawnPosition, spawnRotate = spawnRotate})
        pkgActorManager.AddActor(monster)

        -- InitBehaviourTree(monster)
    end
    
    local tbConfig = _cfg.monster[dMonsterId]
    if not tbConfig then
        LOG_ERROR("Can not find monster id:" .. dMonsterId)
        return
    end

    local strBundldName = tbConfig[pkgConfigFieldDefination.Monster.MODEL_BUNDLE_NAME]
    local strPrefabName = tbConfig[pkgConfigFieldDefination.Monster.MODEL_NAME]
    pkgAssetBundleMgr.LoadAssetBundle(strBundldName, strPrefabName, onLoadComplete)
end

function GetForwardPos(monster, dDistance)

    local spawnForward = UnityEngine.Vector3(1,0,0)
    local currentPosition = pkgSysPosition.GetCurrentPos(monster)
    local forwardPosition = currentPosition + spawnForward * dDistance
    forwardPosition = pkgPositionTool.GetPosOnGround(forwardPosition)
    forwardPosition.z = monster.spawnPosition.z

    return forwardPosition
end

function GetRandomMovePos(monster)
    local randomPosition = monster:GetSpawnPosition()
    local randomX = math.random(1,2)
    local randomZ = math.random(1,2)
    if math.random(1,100) > 50 then
        randomX = randomX * -1
    end
    if math.random(1,100) > 50 then
        randomZ = randomZ * -1
    end
    randomPosition.x = randomPosition.x + randomX
    randomPosition.z = randomPosition.z + randomZ
    local currentPosition = pkgSysPosition.GetCurrentPos(monster)
    if UnityEngine.Vector3.Distance(randomPosition, currentPosition) < 1 then
        randomPosition.x = randomPosition.x * -1
    end

    randomPosition = pkgPositionTool.GetPosOnGround(randomPosition)

    return randomPosition
end

function OnTriggerMonster(trigger)
    for tbMonsterInfo in Slua.iter(trigger.monsters) do
        if not Slua.IsNull(tbMonsterInfo)then
            local dMonsterId = tbMonsterInfo.monsterId
            local spawnTransform = tbMonsterInfo.spawnPosition
            if dMonsterId > 0 then
                local position = spawnTransform.position
                local forward = spawnTransform.forward
                pkgSysMonster.CreateMonster(dMonsterId, position, forward)
            end
        end
    end
end