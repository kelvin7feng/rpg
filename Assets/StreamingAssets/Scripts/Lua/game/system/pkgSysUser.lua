doNameSpace("pkgSysUser")

function OnLogin(dErrorCode, tbUserInfo)
    LOG_INFO("dErrorCode ================ ", dErrorCode)
    LOG_TABLE(tbUserInfo)
end