doNameSpace("pkgSysUser")

function OnLogin(dErrorCode, tbUserInfo)
    LOG_INFO("dErrorCode ================ ", dErrorCode)
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

    pkgSocket.SendToLogic(pkgProtocolDefination.CLIENT_LOGIN.LOGIN, dUserId)
end