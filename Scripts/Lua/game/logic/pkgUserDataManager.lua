doNameSpace("pkgUserDataManager")

m_UserData = nil

function InitUserData(objUserData)
    local objUserData = UserData:new(dHandlerId, objUserData)
    m_UserData = objUserData
end
