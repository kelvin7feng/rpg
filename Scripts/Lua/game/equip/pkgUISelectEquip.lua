doNameSpace("pkgUISelectEquip")

assetbundleTag = "ui"
prefabFile = "EquipSelect"

event_listener = {
   {pkgClientEventDefination.UPDATE_WEAR_EQUIP, "onEquipChange"},
   {pkgClientEventDefination.UPDATE_TAKE_OFF_EQUIP, "onEquipChange"},
}

m_scrollView = m_scrollView or nil
m_panelNoEquip = m_panelNoEquip or nil
m_panelNoSelectedEquip = m_panelNoSelectedEquip or nil
m_panelEquipingPanel = m_panelEquipingPanel or nil
m_dCurrentSlot = m_dCurrentSlot or 0
m_tbTableView = m_tbTableView or nil

function init()
    m_scrollView = gameObject.transform:Find("Panel/Scroll View/Viewport/Content")
    m_panelNoEquip = gameObject.transform:Find("Panel/NoEquip")
    m_panelNoEquip.gameObject:SetActive(false)
    m_panelNoSelectedEquip = gameObject.transform:Find("Panel/NoSelectedEquip")
    m_panelNoSelectedEquip.gameObject:SetActive(false)
    m_panelEquipingPanel = gameObject.transform:Find("Panel/EquipingPanel")
    m_panelEquipingPanel.gameObject:SetActive(false)
end

local function onClickTakeOff(btnGo, strEquipId)
    pkgEquipMgr.TakeOff(m_dCurrentSlot, strEquipId)
end

function onEquipChange(dSlotId)
    show(dSlotId)
end

function updateWearingEquip(dSlotId)

    local strId = pkgUserDataManager.GetEquipSlot(dSlotId)
    if pkgEquipMgr.IsSlotEmpty(dSlotId) then
        m_panelNoSelectedEquip.gameObject:SetActive(true)
        m_panelEquipingPanel.gameObject:SetActive(false)
        return
    end

    m_panelNoSelectedEquip.gameObject:SetActive(false)
    m_panelEquipingPanel.gameObject:SetActive(true)

    local function onLoadCompelte(prefab)
        local strKey = "equipSelector"
        local goNow = m_panelEquipingPanel.transform:Find(strKey)
        if pkgUITool.isNull(goNow) then
            goNow = UnityEngine.Object.Instantiate(prefab)
            goNow.name = strKey
            goNow.transform:SetParent(m_panelEquipingPanel.transform, false)
        end
        goNow.gameObject:SetActive(true)

        local tbEquipInfo = pkgUserDataManager.GetEquip(strId)
        local tbGoodsInfo = pkgGoodsCfgMgr.GetGoodsCfg(tbEquipInfo.cfgId)
        pkgUITool.SetStringByName(goNow, "Name", tbGoodsInfo.name)
        local objIconParent = goNow.transform:Find("EquipIcon/Icon")
        local objIcon = goNow.transform:Find("EquipIcon/Icon/icon")
        if pkgUITool.isNull(objIcon) then
            pkgUITool.CreateIcon(tbEquipInfo.cfgId, objIconParent, nil, {size = pkgUITool.ICON_SIZE_TYPE.SMALL, level = tbEquipInfo.dLevel, tbGoodsInfo = tbGoodsInfo})
        else
            pkgUITool.UpdateIcon(objIcon, tbEquipInfo.cfgId, nil, {size = pkgUITool.ICON_SIZE_TYPE.SMALL, level = tbEquipInfo.dLevel, tbGoodsInfo = tbGoodsInfo})
        end
        
        pkgUITool.SetActiveByName(goNow, "Wear", false)
        pkgUITool.SetActiveByName(goNow, "TakeOff", true)

        pkgButtonMgr.RemoveListeners(goNow, "TakeOff")
        pkgButtonMgr.AddListener(goNow, "TakeOff", onClickTakeOff, tbEquipInfo.id)
    end

    pkgAssetBundleMgr.LoadAssetBundle("ui", "EquipSelector", onLoadCompelte)
end

local function onClickWear(btnGo, strEquipId)
    pkgEquipMgr.WearEquip(m_dCurrentSlot, strEquipId)
end

function getTableViewData(dSlotId)
    return pkgUserDataManager.GetEquipListWithoutSlot(dSlotId)
end

function createTableViewCard(dSlotId)

    local tbEquipList = getTableViewData(dSlotId)
    if #tbEquipList <= 0 then
        m_panelNoEquip.gameObject:SetActive(true)
    else
        m_panelNoEquip.gameObject:SetActive(false)
    end

    local function onComplete(prefab)
        if not prefab then return end

        local delegateSource = {
            dOffsetStart = 15,  --开头的偏移
            dOffsetCell = 10,   --每个cell的间隔
            dCellInterval = 10, --每行的间距
        }

        local dataSource = {}

        local tbData = getTableViewData(dSlotId)

        function dataSource.column()
            return 1
        end

        function dataSource.total()
            return #tbData
        end

        function dataSource.tbData()
            return tbData
        end

        function delegateSource.scrollView()
            return gameObject.transform:Find("Panel/Scroll View")
        end

        function delegateSource.setDataAtCell(cell, dIndexInData, _tbData)

            local tbEquipInfo = _tbData[dIndexInData]
            local tbGoodsInfo = pkgGoodsCfgMgr.GetGoodsCfg(tbEquipInfo.cfgId)
            pkgUITool.SetStringByName(cell, "Name", tbGoodsInfo.name)
            local objIconParent = cell.transform:Find("EquipIcon/Icon")
            local objIcon = cell.transform:Find("EquipIcon/Icon/icon")
            if pkgUITool.isNull(objIcon) then
                pkgUITool.CreateIcon(tbEquipInfo.cfgId, objIconParent, nil, {size = pkgUITool.ICON_SIZE_TYPE.SMALL, level = tbEquipInfo.dLevel, tbGoodsInfo = tbGoodsInfo})
            else
                pkgUITool.UpdateIcon(objIcon, tbEquipInfo.cfgId, nil, {size = pkgUITool.ICON_SIZE_TYPE.SMALL, level = tbEquipInfo.dLevel, tbGoodsInfo = tbGoodsInfo})
            end

            pkgUITool.SetActiveByName(cell, "Wear", true)
            pkgUITool.SetActiveByName(cell, "TakeOff", false)

            pkgButtonMgr.RemoveListeners(cell, "Wear")
            pkgButtonMgr.AddListener(cell, "Wear", onClickWear, tbEquipInfo.id)
        end

        function delegateSource.cellByPrefab()
            return prefab
        end
        if not m_tbTableView then
            m_tbTableView = pkgUITableViewMgr.createTableView(delegateSource, dataSource)
        else
            local tbData = getTableViewData(dSlotId)
            pkgUITableViewMgr.setData(m_tbTableView, tbData, true)
        end
    end
    
    pkgAssetBundleMgr.LoadAssetBundle("ui", "EquipSelector", onComplete)
end

function show(dSlotId)

    m_dCurrentSlot = dSlotId
    updateWearingEquip(dSlotId)
    -- updateFreeEquip(dSlotId)
    createTableViewCard(dSlotId)
end

function destroyUI()
    pkgUIBaseViewMgr.destroyUI(pkgUISelectEquip)
end

function close()
    m_scrollView = nil
    m_panelNoEquip = nil
    m_panelNoSelectedEquip = nil
    m_panelEquipingPanel = nil
    m_dCurrentSlot = 0
    m_tbTableView = nil
end