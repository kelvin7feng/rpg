doNameSpace("pkgSysAI")

function UpdateCheckFOV()
    local tbAIPlayer = pkgActorManager.GetAllAIPlayer()
    for _, player in ipairs(tbAIPlayer) do
        local bHateCount = player.aiData:GetHateListCount()
        local dDistanceOfFOV = player.aiData:GetFieldConfig(pkgConfigFieldDefination.Monster.DISTANCE_OF_FOV)
        local bIsOk, tbEnemy = PlayerInCone(player, dDistanceOfFOV, 120)
        if bIsOk then
            for _, enemy in ipairs(tbEnemy) do
                pkgSysHate.AddHate(player, enemy:GetId(), 1)
            end

            if bHateCount <= 0 and #tbEnemy > 0 
                and not player.aiData.bInterruptByHate then
                player.aiData.bInterruptByHate = true
            end
        end
    end
end

function PlayerInCone(player, dRadius, dAngle)
    
    local dHalfAngle = dAngle / 2
    local posSelfOwner = pkgSysPosition.GetCurrentPos(player)
    local forwardDir = pkgSysPosition.GetForwardDir(player)
    local tbTargetsInView = pkgActorManager.GetAllEnemy(player)
    local tbEnemy = {}

    if #tbTargetsInView > 0 then
        for _, enemy in pairs(tbTargetsInView) do
            if not pkgSysHate.DoesExistEnemy(player, enemy:GetId()) 
                and not APICondition.IsDead(enemy) then
                local targetPos = pkgSysPosition.GetCurrentPos(enemy)
                local dDistance = UnityEngine.Vector3.Distance(targetPos, posSelfOwner)
                if dDistance <= dRadius then
                    local dirToTarget = (targetPos - posSelfOwner).normalized
                    local dTempAngle = UnityEngine.Vector3.Angle(forwardDir, dirToTarget)
                    if dTempAngle < dHalfAngle then
                        table.insert(tbEnemy, enemy)
                    end
                end
            end
        end
    end
  
    if #tbEnemy > 0 then
      return true, tbEnemy
    end
  
    return false
end

function RemoveDeadPlayer(deadPlayer)
    local tbAIPlayer = pkgActorManager.GetAllAIPlayer()
    for _, player in ipairs(tbAIPlayer) do
        pkgSysHate.RemoveEnemy(player, deadPlayer:GetId())
    end
end

function AddAttackerToHateList(player, attacker)
    
    if player.aiData and not player.aiData.bIsHurt then
        player.aiData.bIsHurt = true
    end

    pkgSysHate.AddHate(player, attacker:GetId(), 1)
end

function SetPause(player, bIsPause)
    if player and player.aiData then
        player.aiData:SetPause(bIsPause)
    end
end

function GetPause(player)
    return player.aiData.bIsPause
end