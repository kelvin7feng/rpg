doNameSpace("pkgSysPlayer")

function SetStoppingDistance(player, dStoppingDistance)

    if not player.navMeshAgent then
        return
    end

    if dStoppingDistance < 0 then
        dStoppingDistance = 0
    end
    
    player.navMeshAgent.stoppingDistance = dStoppingDistance
end

function SetAnimationMoveSpeed(player, dAnimationMoveSpeed)
    player.dAnimationMoveSpeed = dAnimationMoveSpeed
end

function GetAnimationMoveSpeed(player)
    return player.dAnimationMoveSpeed
end

function SetMoveSpeed(player, dMoveSpeed)
    player.dMoveSpeed = dMoveSpeed
end

function GetMoveSpeed(player)
    return player.dMoveSpeed
end

function Die(player)
    player:SetDie(true)
    local animator = player.animator
    if animator then
        LOG_DEBUG("Die,", pkgAnimatorDefination.AnimatorParamter.ANIMATION_TYPE, pkgAnimatorDefination.AnimationType.DIE)
        pkgAnimatorMgr.SetInteger(animator, pkgAnimatorDefination.AnimatorParamter.ANIMATION_TYPE, pkgAnimatorDefination.AnimationType.DIE)
        pkgAnimatorMgr.SetTrigger(animator, pkgAnimatorDefination.AnimatorParamter.DIE_ONCE)
    end

    if pkgActorManager.IsAIPlayer(player) then
        pkgSysMonster.StopBehaviour(player)
    end

    pkgSysAI.RemoveDeadPlayer(player)

    -- 移除nav agent
    player:SetNavMeshEnable(false)
end

function Stay(player)
    local animator = player.animator
    if animator then
        pkgAnimatorMgr.SetInteger(animator, pkgAnimatorDefination.AnimatorParamter.ANIMATION_TYPE, pkgAnimatorDefination.AnimationType.STAY)
    end    
end

function TriggerReborn(player)
    local bIsOk = false
    local animator = player.animator
    if animator then
        pkgAnimatorMgr.SetTrigger(animator, pkgAnimatorDefination.AnimatorParamter.REBORN)
        bIsOk = true
    end

    return bIsOk
end

function MoveToDestination(player, pos)
    if pkgFSMManger.IsInState(player, pkgStateDefination.State.ATTACK) then
        return false
    end

    if not player then
        return
    end

    local playerController = player.playerController
    if playerController then
        playerController:SetMoveSpeed(GetMoveSpeed(player))
        playerController:SetDestination(pos.x, pos.y, pos.z)
    end

    local animator = player.animator
    if animator then
        pkgAnimatorMgr.SetInteger(animator, pkgAnimatorDefination.AnimatorParamter.ANIMATION_TYPE, pkgAnimatorDefination.AnimationType.MOVE)
        pkgAnimatorMgr.SetFloat(animator, pkgAnimatorDefination.AnimatorParamter.SPEED, GetAnimationMoveSpeed(player))
    end
end

function SetDestination(player, pos)
    if not player then
        return
    end
    
    player.inputDestination = pos
end

function ClacDestination(player, x, y, z)
    local dir = UnityEngine.Vector3(x, y, z)
    local camera = UnityEngine.Camera.main
    local cameraRotatedDir = camera.transform:TransformDirection(dir)
    local rotatedDir = UnityEngine.Vector3(cameraRotatedDir.x, 0, cameraRotatedDir.z)
    rotatedDir = rotatedDir.normalized * dir.magnitude
    local pos = player.transform.position + rotatedDir
    return pos
end

function Stop(player)
    if not player then
        return
    end

    local playerController = player.playerController
    if playerController then
        playerController:Stop()
    end

    local animator = player.animator
    if animator then
        pkgAnimatorMgr.SetInteger(animator, pkgAnimatorDefination.AnimatorParamter.ANIMATION_TYPE, pkgAnimatorDefination.AnimationType.STAY)
        pkgAnimatorMgr.SetFloat(animator, pkgAnimatorDefination.AnimatorParamter.SPEED, 0)
    end
end

function GetSpawnPosition()
    local spawnPosition = UnityEngine.Vector3.zero
    local gameObject = UnityEngine.GameObject.Find("SpawnPoint")
    if gameObject then
        spawnPosition = gameObject.transform.position
    end
    return spawnPosition
end

function GetSpawnRotate()
    local spawnRotate = nil
    local gameObject = UnityEngine.GameObject.Find("SpawnPoint")
    if gameObject then
        spawnRotate = gameObject.transform.forward
    end
    return spawnRotate
end

function OnNavMeshAgentStop(dPlayerId)

    local player = pkgActorManager.GetActor(dPlayerId)
    if not player then
        return false
    end

    pkgSysPlayer.SetDestination(player,nil)

    local animator = player.animator
    if animator then
        pkgAnimatorMgr.SetInteger(animator, pkgAnimatorDefination.AnimatorParamter.ANIMATION_TYPE, pkgAnimatorDefination.AnimationType.STAY)
        pkgAnimatorMgr.SetFloat(animator, pkgAnimatorDefination.AnimatorParamter.SPEED, 0)
    end
end

function GetHurt(player)
    local animator = player.animator
    if animator then
        pkgAnimatorMgr.SetInteger(animator, pkgAnimatorDefination.AnimatorParamter.ANIMATION_TYPE, pkgAnimatorDefination.AnimationType.HURT)
    end 
end

function OnHitPlayer(dPlayerId, objWeapon)
    local player = pkgActorManager.GetActor(dPlayerId)
    if not player then
        return false
    end

    if pkgFSMManger.IsInState(player, pkgStateDefination.State.ATTACK) then
        pkgSysEffect.PlayWeaponEffect(objWeapon)
    end
end

function OnPlayerDie(dPlayerId, objWeapon)
    local player = pkgActorManager.GetActor(dPlayerId)
    if not player then
        return false
    end

    Destory(player)
end

function Destory(player)
    pkgActorManager.Remove(player)
    pkgSysMonster.StopBehaviour(player)
    pkgFSMManger.RemoveFSM(player.fsm)
    pkgSysHate.ClearHateList(player)
    UnityEngine.Object.Destroy(player.gameObject)
end

function Reborn(player)
    if not player then
        return
    end

    local tbMostHatedEnemy = pkgSysHate.GetMostHatedEnemy(player)
    if tbMostHatedEnemy then
        Destory(tbMostHatedEnemy)
    end

    pkgTimer.AddOnceTimer("Reborn", 1, 
        function()
            player.stat:FullHp()
            player:SetDie(false)
            player:SetNavMeshEnable(true)
            pkgSysHate.ClearHateList(player)
            pkgEventManager.PostEvent(pkgClientEventDefination.PLAYER_HP_CHANGE, player)

            if not TriggerReborn(player) then
                return
            end

            pkgSysMonster.StartBehaviour(player)

            pkgSocket.SendToLogic(EVENT_ID.CLIENT_BATTLE.READY)
    end)

end