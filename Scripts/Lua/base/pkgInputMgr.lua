doNameSpace("pkgInputMgr")

m_bInputDir = false

function Update()
    UpdatePlayerInput()
    -- UpdateVirtualController()
    -- UpdateKeyBoradController()
end

function UpdateKeyBoradController()
    if UnityEngine.Input.GetKey(UnityEngine.KeyCode.W) or UnityEngine.Input.GetKey(UnityEngine.KeyCode.S)
        or UnityEngine.Input.GetKey(UnityEngine.KeyCode.A) or UnityEngine.Input.GetKey(UnityEngine.KeyCode.D) then  
        local player = pkgActorManager.GetMainPlayer()
        local destination = pkgSysPlayer.ClacDestination(player, UnityEngine.Input.GetAxis("Horizontal"), 0, UnityEngine.Input.GetAxis("Vertical"))
        pkgSysPlayer.SetDestination(player,destination)
        pkgSysPlayer.SetAnimationMoveSpeed(player, 1)
        m_bInputDir = true
    end

    local bInputDir = false
    if math.abs(UnityEngine.Input.GetAxisRaw("Horizontal")) > 0 
        or math.abs(UnityEngine.Input.GetAxisRaw("Vertical")) > 0 then
        bInputDir = true
    end

    if not bInputDir and m_bInputDir then
        m_bInputDir = false
        local player = pkgActorManager.GetMainPlayer()
        pkgSysPlayer.SetDestination(player,nil)
        pkgSysPlayer.SetAnimationMoveSpeed(player, 0)
    end
end

function UpdatePlayerInput()

    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.T) then
        pkgSysSkill.SetAttackSkill(pkgActorManager.GetMainPlayer(), 0)
    end

    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.I) then
        pkgSocket.SendToLogic(EVENT_ID.CLIENT_LOGIN.LOGIN,100)
    end

    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.K) then
        pkgSysStat.DoDamage(pkgActorManager.GetMainPlayer(), nil, 1)
    end

    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.C) then
        local tbAIPlayer = pkgActorManager.GetAllAIPlayer()
        for _, player in ipairs(tbAIPlayer) do
            pkgSysStat.DoDamage(player, pkgActorManager.GetMainPlayer(), 1)
        end
    end

    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.P) then
        -- pkgSysEffect.PlayEffect(1)
        pkgFlyWordUI.PlayFlyWord(pkgActorManager.GetMainPlayer(), 1, 5)
    end

    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.L) then
        pkgSocket.Disconnect()
    end

    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.U) then
        pkgSocket.ReceiveMsg()
    end

    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.R) then
        pkgSocket.Reconnect()
    end
    
    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.B) then
        pkgSocket.SendToLogic(EVENT_ID.CLIENT_BATTLE.READY)
    end
end

function UpdateVirtualController()
    pkgVirtualController.UpdateVirtualController()
end