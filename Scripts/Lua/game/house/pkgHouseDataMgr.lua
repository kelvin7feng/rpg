doNameSpace("pkgHouseDataMgr")

function GetLevel()
    local dLevel = 0
    local tbHouseInfo = pkgUserDataManager.GetHouseInfo()
    if tbHouseInfo and tbHouseInfo.dLevel then
        dLevel = tbHouseInfo.dLevel
    end

    return dLevel
end

function SetLevel(dLevel)
    local tbHouseInfo = pkgUserDataManager.GetHouseInfo()
    if tbHouseInfo and tbHouseInfo.dLevel then
        tbHouseInfo.dLevel = dLevel
    end
end

function GetStar()
    local dStar = 0
    local tbHouseInfo = pkgUserDataManager.GetHouseInfo()
    if tbHouseInfo and tbHouseInfo.dLevel then
        dStar = tbHouseInfo.dStar
    end

    return dStar
end

function SetStar(dStar)
    local tbHouseInfo = pkgUserDataManager.GetHouseInfo()
    if tbHouseInfo and tbHouseInfo.dLevel then
        tbHouseInfo.dStar = dStar
    end
end