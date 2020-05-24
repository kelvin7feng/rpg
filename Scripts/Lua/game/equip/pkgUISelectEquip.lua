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
    if IsStringEmpty(strId) then
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
        local imgGoods = goNow.transform:Find("EquipIcon/Image")
        if imgGoods then
            pkgUITool.ResetImage("equip_icon", tostring(tbGoodsInfo.id), imgGoods)
        end
        
        pkgUITool.SetActiveByName(goNow, "Wear", false)
        pkgUITool.SetActiveByName(goNow, "TakeOff", true)
        pkgUITool.SetStringByName(goNow, "EquipIcon/Level", tbEquipInfo.dLevel)

        pkgButtonMgr.RemoveListeners(goNow, "TakeOff")
        pkgButtonMgr.AddListener(goNow, "TakeOff", onClickTakeOff, tbEquipInfo.id)
    end

    pkgAssetBundleMgr.LoadAssetBundle("ui", "EquipSelector", onLoadCompelte)
end

local function onClickWear(btnGo, strEquipId)
    pkgEquipMgr.WearEquip(m_dCurrentSlot, strEquipId)
end

function resetScrollViewItem()
    for i=0, m_scrollView.transform.childCount - 1 do
        local goChild = m_scrollView.transform:GetChild(i).gameObject
        goChild.gameObject:SetActive(false)
    end
end

function updateFreeEquip(dSlotId)
    local tbEquipList = pkgUserDataManager.GetEquipListWithoutSlot(dSlotId)

    resetScrollViewItem()
    
    if #tbEquipList <= 0 then
        m_panelNoEquip.gameObject:SetActive(true)
    else
        local function onLoadCompelte(prefab)
            for i, tbEquipInfo in ipairs(tbEquipList) do
                local strKey = "equipSelector" .. i
                local goNow = m_scrollView.transform:Find(strKey)
                if pkgUITool.isNull(goNow) then
                    goNow = UnityEngine.Object.Instantiate(prefab)
                    goNow.name = strKey
                    goNow.transform:SetParent(m_scrollView.transform, false)
                end
                goNow.gameObject:SetActive(true)

                local tbGoodsInfo = pkgGoodsCfgMgr.GetGoodsCfg(tbEquipInfo.cfgId)
                pkgUITool.SetStringByName(goNow, "Name", tbGoodsInfo.name)
                local imgGoods = goNow.transform:Find("EquipIcon/Image")
                if imgGoods then
                    pkgUITool.ResetImage("equip_icon", tostring(tbGoodsInfo.assetName), imgGoods)
                end
                
                pkgUITool.SetStringByName(goNow, "EquipIcon/Level", tbEquipInfo.dLevel)

                pkgUITool.SetActiveByName(goNow, "Wear", true)
                pkgUITool.SetActiveByName(goNow, "TakeOff", false)

                pkgButtonMgr.RemoveListeners(goNow, "Wear")
                pkgButtonMgr.AddListener(goNow, "Wear", onClickWear, tbEquipInfo.id)
            end
        end
    
        pkgAssetBundleMgr.LoadAssetBundle("ui", "EquipSelector", onLoadCompelte)
    end
end

function show(dSlotId)

    m_dCurrentSlot = dSlotId
    updateWearingEquip(dSlotId)
    updateFreeEquip(dSlotId)
    
end

function destroyUI()
    
end

function close()
    
end