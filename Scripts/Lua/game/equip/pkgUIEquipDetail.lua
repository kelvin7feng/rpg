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
    m_panelAttr = goParent.transform:Find("AttrPanel")
    m_txtEquipDesc = goParent.transform:Find("TxtEqupDesc")
    m_btnLevelUp = goParent.transform:Find("BtnPanel/BtnLevelUp")
    m_btnReplace = goParent.transform:Find("BtnPanel/BtnReplace")
end

function resetAttrItem()
    for i=0, m_panelAttr.transform.childCount - 1 do
        local goChild = m_panelAttr.transform:GetChild(i).gameObject
        goChild.gameObject:SetActive(false)
    end
end

function show(strId)

    resetAttrItem()
    
    local tbEquipInfo = pkgUserDataManager.GetEquip(strId)
    local dEquipCfgId = tbEquipInfo.cfgId
    local tbGoodsInfo = pkgGoodsCfgMgr.GetGoodsCfg(dEquipCfgId)
    pkgUITool.UpdateGameObjectText(m_txtName, tbGoodsInfo.languageId)
    
    local function onClickIcon()
        
    end

    local strIconName = "icon"
    local icon = m_panelIcon.transform:Find(strIconName)
    if pkgUITool.isNull(icon) then
        pkgUITool.CreateIcon(dEquipCfgId, m_panelIcon, nil, {onClick = onClickIcon})
    end

    local tbAttr = pkgEquipCfgMgr.GetAttrDescList(dEquipCfgId)
    for i, strAttr in ipairs(tbAttr) do
        pkgUITool.SetStringByName(m_panelAttr, "TxtAttr"..i, strAttr)
        pkgUITool.SetActiveByName(m_panelAttr, "TxtAttr"..i, true)
    end

    local function onClickLevelUp(btnGo)
        print("show level up panel")
    end

    local function onClickReplace(btnGo)
        local tbCfg = pkgEquipCfgMgr.GetEquipCfg(dEquipCfgId)
        pkgUIBaseViewMgr.showByViewPath("game/equip/pkgUISelectEquip", nil, tbCfg.slot)
    end

    pkgButtonMgr.AddBtnListener(m_btnLevelUp, onClickLevelUp)
    pkgButtonMgr.AddBtnListener(m_btnReplace, onClickReplace)
end

function destroyUI()
    
end

function close()
    
end