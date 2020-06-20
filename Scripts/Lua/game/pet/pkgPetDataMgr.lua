doNameSpace("pkgPetDataMgr")

function GetPetTeam()
    local tbPetInfo = pkgUserDataManager.GetPetInfo()
    return tbPetInfo.tbTeam
end

function GetPetList()
    local tbPetInfo = pkgUserDataManager.GetPetInfo()
    return tbPetInfo.tbPetList
end
