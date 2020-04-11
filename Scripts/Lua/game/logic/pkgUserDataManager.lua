doNameSpace("pkgUserDataManager")

m_UserData = nil

local function sortFromBestToNormal(a,b)
    local tbCfg1 = pkgEquipCfgMgr.GetEquipCfg(a.cfgId)
    local tbCfg2 = pkgEquipCfgMgr.GetEquipCfg(b.cfgId)
    if tbCfg1.quality ~= tbCfg2.quality then
        return tbCfg1.quality > tbCfg2.quality
    elseif tbCfg1.slot ~= tbCfg2.slot then
        return tbCfg1.slot < tbCfg2.slot
    else
        return tbCfg1.id > tbCfg2.id
    end
end

local function sortGoodsByDefault(a,b)
    return tbCfg1.id > tbCfg2.id
end

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
            table.insert(tbShowBag, {id = strType, count = dCount, assets = tbCfg.assetBundle})
        end
        table.sort(tbShowBag,sortGoodsByDefault)
    end

    local tbEquipList = GetEquipList()
    if #tbEquipList > 0 then
        for _, tbEquip in ipairs(tbEquipList) do
            tbCfg = pkgGoodsCfgMgr.GetGoodsCfg(tbEquip.cfgId)
            if tbCfg and tbCfg.isBag == 1 then
                table.insert(tbShowBag, {id = tbEquip.cfgId, count = 1, assets = tbCfg.assetBundle})
            end
        end
    end

    return tbShowBag
end

function SetBagVal(dType, dCount)
    if dCount == 0 then
        m_UserData.BagInfo[tostring(dType)] = nil
        return
    end
    local tbCfg = pkgGoodsCfgMgr.GetGoodsCfg(dType)
    if tbCfg then
        m_UserData.BagInfo[tostring(dType)] = dCount
    end
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
    
    local tb = {}
    local tbEquipList = m_UserData.EquipInfo.tbEquipList
    for _, tbEquip in pairs(tbEquipList) do
        table.insert(tb, tbEquip)
    end

    table.sort(tb, sortFromBestToNormal)

    return tb
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

    table.sort(tb, sortFromBestToNormal)
	
    return tb
end
