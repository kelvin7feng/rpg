doNameSpace("pkgUserDataManager")

m_UserData = nil

function InitUserData(objUserData)
    m_UserData = objUserData
end

function GetLevel()
    LOG_TABLE(m_UserData)
    return m_UserData.BattleInfo.CurLevel
end

function GetName()
    return m_UserData.BaseInfo.Name
end

function GetBag()
    local tbShowBag = {}
    local tbBagInfo = m_UserData.BagInfo
    local tbCfg = nil
    for strType, dCount in pairs(tbBagInfo) do
        tbCfg = pkgGoodsCfgMgr.GetGoodsCfg(strType)
        if tbCfg and tbCfg.isBag == 1 then
            table.insert(tbShowBag, {id = strType, count = dCount})
        end
    end

    return tbShowBag
end

function SetBagVal(dType, dCount)
    if dCount == 0 then
        m_UserData.BagInfo[tostring(dType)] = nil
        return
    end
    m_UserData.BagInfo[tostring(dType)] = dCount
end

function GetBagVal(dType)
    return m_UserData.BagInfo[tostring(dType)] or 0
end

function GetGold()
    return GetBagVal(GOODS_DEF.GOLD)
end

function GetDiamond()
    return GetBagVal(GOODS_DEF.DIAMOND)
end