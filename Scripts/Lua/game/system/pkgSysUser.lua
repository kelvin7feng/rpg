doNameSpace("pkgSysUser")

function OnLevelChange(dLevel)
    Toast(pkgLanguageMgr.GetStringById(2001, dLevel))
    pkgUserDataManager.SetLevel(dLevel)
    if pkgActorManager.GetMainPlayer() then
        pkgAttrLogic.CalcPlayerAttr(pkgActorManager.GetMainPlayer())
    end
    pkgEventManager.PostEvent(pkgClientEventDefination.UPDATE_USER_LEVEL, dLevel)
end

function OnLogin(dErrorCode, tbUserInfo)

    if ERROR_CODE.SYSTEM.OK ~= dErrorCode then
        -- to do
        LOG_INFO("dErrorCode ================ ", dErrorCode)
    end

    -- 初始化玩家数据
    pkgUserDataManager.InitUserData(tbUserInfo)
    LOG_TABLE(tbUserInfo)
    
    local function onSwitch()
        pkgGameController.Init()
    end
    pkgSceneMgr.SwitchScene(pkgGlobalConfig.SceneName.GAME, UnityEngine.SceneManagement.LoadSceneMode.Single, onSwitch)
end

function Login(dUserId)
    if not dUserId then
        return
    end

    if not IsNumber(dUserId) then
        return
    end

    pkgSocket.SendToLogic(EVENT_ID.CLIENT_LOGIN.LOGIN, dUserId)
end