doNameSpace("pkgProtocolManager")

function InitProtocol()
    -- 玩家基本信息
    pkgEventManager.Register(pkgProtocolDefination.CLIENT_LOGIN.LOGIN, pkgSysUser.OnLogin)
end