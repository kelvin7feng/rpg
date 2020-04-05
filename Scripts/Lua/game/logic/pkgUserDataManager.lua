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
            table.insert(tbShowBag, {id = strType, count = dCount, assets = "goods"})
        end
    end

    local tbEquipList = GetEquipList()
    for _, tbEquip in pairs(tbEquipList) do
        tbCfg = pkgGoodsCfgMgr.GetGoodsCfg(tbEquip.cfgId)
        if tbCfg and tbCfg.isBag == 1 then
            table.insert(tbShowBag, {id = tbEquip.cfgId, count = 1, assets = "equip_icon"})
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

function GetEquipList()
    local tbEquipList = m_UserData.EquipInfo.tbEquipList
    return tbEquipList
end

function GetEquip(strId)
    if not strId then
        return
    end
    return m_UserData.EquipInfo.tbEquipList[strId]
end

function SetEquip(strId, tbEquip)
    if not strId or not tbEquip then
        return
    end
    m_UserData.EquipInfo.tbEquipList[strId] = tbEquip
end

function GetEquipSlots()
    local tbSlot = m_UserData.EquipInfo.tbSlot
    return tbSlot
end

function GetEquipSlot(i)
    local strId = m_UserData.EquipInfo.tbSlot[i]
    return strId
end

function SetEquipSlot(i, strId)
    m_UserData.EquipInfo.tbSlot[i] = strId
end

function GetEquipListBySlot(i)
    local tb = {}
    local tbEquipList = GetEquipList()
    for _, tbEquip in pairs(tbEquipList) do
        local tbCfg = pkgEquipCfgMgr.GetEquipCfg(tbEquip.cfgId)
        if tbCfg and tbCfg.slot == i then
            table.insert(tb, tbEquip)
        end
    end

    return tb
end

function GetEquipListWithoutSlot(i)
    local tb = {}
    local strId = GetEquipSlot(i)
    local tbEquipList = GetEquipList()
    for _, tbEquip in pairs(tbEquipList) do
        local tbCfg = pkgEquipCfgMgr.GetEquipCfg(tbEquip.cfgId)
        if tbCfg and tbCfg.slot == i and tbEquip.id ~= strId then
            table.insert(tb, tbEquip)
        end
    end
	
    return tb
end