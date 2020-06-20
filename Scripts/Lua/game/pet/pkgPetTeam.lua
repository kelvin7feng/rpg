doNameSpace("pkgPetTeam")

function CreatePet(player, dMonsterId, spawnPosition, spawnRotate, dPosId)

    local function onLoadComplete(prefab)
        local pet = Pet:new({dMonsterId = dMonsterId, dSide = player.dSide, prefab = prefab, spawnPosition = spawnPosition, spawnRotate = spawnRotate})
        pet.aiData:SetFollowTarget(player)
        pet.aiData.dPosId = dPosId

        pkgSysMonster.InitBehaviourTree(pet)

        pkgActorManager.AddActor(pet)
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

function GetTeamPos(player, dIndex)
    if dIndex <= 0 or dIndex > 6 then
        return nil
    end

    local bRight = math.fmod(dIndex, 2) == 0 and true or false
    local dRightDistance = bRight and -2 or 2
    local dBackDistance = 0
    if dIndex <= 2 then
        dBackDistance = -1
    elseif dIndex <= 4 then
        dBackDistance = -2
    elseif dIndex <= 6 then
        dBackDistance = -3
    end

    local spawnBackward = UnityEngine.Vector3(dBackDistance,0,0)
    local spawnRight = UnityEngine.Vector3(0,0,dRightDistance)
    local currentPosition = pkgSysPosition.GetCurrentPos(player)
    local teamPosition = currentPosition + spawnBackward + spawnRight
    teamPosition = pkgPositionTool.GetPosOnGround(teamPosition)

    return teamPosition
end

function CreatePlayerTeam(player)
    local tbTeam = pkgPetDataMgr.GetPetTeam()
    tbTeam[1] = "10001"
    for i, strPetId in ipairs(tbTeam) do
        local dPetId = tonumber(strPetId)
        if dPetId > 0 then
            local spawnPosition = GetTeamPos(player, i)
            local forwardDir = pkgSysPosition.GetForwardDir(player)
            CreatePet(player, dPetId, spawnPosition, forwardDir, i)
        end
    end
end