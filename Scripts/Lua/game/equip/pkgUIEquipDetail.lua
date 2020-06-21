doNameSpace("pkgUIEquipDetail")

assetbundleTag = "ui"
prefabFile = "EquipDetail"

event_listener = {

}

m_txtName = m_txtName or nil
m_txtQuality = m_txtQuality or nil
m_panelIcon = m_panelIcon or nil
m_txtPower = m_txtPower or nil
m_txtType = m_txtType or nil
m_panelAttr = m_panelAttr or nil
m_txtEquipDesc = m_txtEquipDesc or nil
m_btnLevelUp = m_btnLevelUp or nil
m_btnReplace = m_btnReplace or nil

function init()
    local goParent = gameObject.transform:Find("Panel/DetailPanel")
    m_txtName = goParent.transform:Find("TxtName")
    m_txtQuality = goParent.transform:Find("TxtQuality")
    m_panelIcon = goParent.transform:Find("Icon")
    m_txtPower = goParent.transform:Find("TxtPower")
    m_txtType = goParent.transform:Find("TxtType")
    m_panelAttr = goParent.transform:Find("PanelAttr/AttrPanel")
    m_txtEquipDesc = goParent.transform:Find("TxtEquipDesc")
    m_btnLevelUp = goParent.transform:Find("BtnPanel/BtnLevelUp")
    m_btnReplace = goParent.transform:Find("BtnPanel/BtnReplace")

    pkgUITool.SetActive(m_btnLevelUp, false)
    pkgUITool.SetActive(m_btnReplace, false)
end

function show(tbParams)
    
    local strId = tbParams.strEquipId
    local dCfgId = tbParams.dCfgId
    local bIsShop = tbParams.bIsShop
    local bIsBag = tbParams.bIsBag
    local bIsSlot = tbParams.bIsSlot

    local tbEquipInfo = nil
    local dEquipCfgId = dCfgId
    if strId then
        tbEquipInfo = pkgUserDataManager.GetEquip(strId)
        dEquipCfgId = tbEquipInfo.cfgId
    end

    local tbGoodsInfo = pkgGoodsCfgMgr.GetGoodsCfg(dEquipCfgId)
    pkgUITool.SetGameObjectString(m_txtName, tbGoodsInfo.name)
    
    local function onClickIcon()
        
    end

    local strIconName = "icon"
    local icon = m_panelIcon.transform:Find(strIconName)
    if pkgUITool.isNull(icon) then
        pkgUITool.CreateIcon(dEquipCfgId, m_panelIcon, nil, {onClick = onClickIcon, size = pkgUITool.ICON_SIZE_TYPE.SMALL})
    end

    local tbCfg = pkgEquipCfgMgr.GetEquipCfg(dEquipCfgId)
    local tbAttr = pkgAttrCfgMgr.GetAttrDescList(tbCfg.attrId)
    pkgUIAttrMgr.UpdateAttrPanel(m_panelAttr, tbAttr)

    local function onClickLevelUp(btnGo)
        pkgUIBaseViewMgr.showByViewPath("game/equip/pkgUIEquipLevelUp", nil, strId)
        pkgUIBaseViewMgr.destroyUI(pkgUIEquipDetail)
    end

    local function onClickReplace(btnGo)
        pkgUIBaseViewMgr.showByViewPath("game/equip/pkgUISelectEquip", nil, tbCfg.slot)
        pkgUIBaseViewMgr.destroyUI(pkgUIEquipDetail)
    end

    if bIsSlot then
        pkgButtonMgr.AddBtnListener(m_btnLevelUp, onClickLevelUp)
        pkgButtonMgr.AddBtnListener(m_btnReplace, onClickReplace)
        pkgUITool.SetActive(m_btnLevelUp, true)
        pkgUITool.SetActive(m_btnReplace, true)
    end

    if bIsShop then

    end

    if bIsBag then

    end
end

function destroyUI()
    pkgUIBaseViewMgr.destroyUI(pkgUIEquipDetail)
end

function close()
    
end