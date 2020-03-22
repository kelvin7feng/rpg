doNameSpace("pkgUserDataManager")

m_UserData = nil

function InitUserData(objUserData)
    m_UserData = objUserData
end

function GetLevel()
    LOG_TABLE(m_UserData)
    return m_UserData.BattleInfo.CurLevel
end