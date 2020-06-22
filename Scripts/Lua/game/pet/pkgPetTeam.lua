doNameSpace("pkgPetTeam")

function CreatePet(callback, tbParams)

    local dMonsterId = tbParams.dMonsterId
    local function onLoadComplete(prefab)

        tbParams.prefab = prefab

        local player = tbParams.owner
        local pet = Pet:new(tbParams)

        pet.aiData:SetFollowTarget(player)
        pet.aiData.dPosId = tbParams.dPosId
        pet.gameObject:SetActive(false)

        pkgSysMonster.InitBehaviourTree(pet, true)
        
        pkgActorManager.AddActor(pet)

        if callback then
            callback(pet, tbParams)
        end
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

function GetPlayPet(player, dPosId)
    if not player or not dPosId then
        return
    end
    return player.tbPet[dPosId]
end

function SetPlayPet(player, pet, dPosId)
    if not player or not pet or not dPosId then
        return
    end
    player.tbPet[dPosId] = pet
end

function CreateOnePet(player, dPosId, dPetId, funcCallback)
    
    local function callback(pet, tbParams)
        pet.gameObject:SetActive(true)
        SetPlayPet(player, pet, dPosId)
        if funcCallback then
            funcCallback()
        end
    end

    local spawnPosition = GetTeamPos(player, dPosId)
    local forwardDir = pkgSysPosition.GetForwardDir(player)
    local tbParams = {owner = player, dMonsterId = dPetId, dSide = player.dSide, dPosId = dPosId,
                      spawnPosition = spawnPosition, spawnRotate = forwardDir}
    CreatePet(callback, tbParams)
end

function CreatePlayerTeam(player)
    local tbTeam = pkgPetDataMgr.GetPetTeam()
    for dPosId, strPetId in ipairs(tbTeam) do
        local dPetId = tonumber(strPetId)
        if dPetId > 0 then
            CreateOnePet(player, dPosId, dPetId)
        end
    end
end