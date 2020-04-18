doNameSpace("pkgUIEquipLevelUp")

assetbundleTag = "ui"
prefabFile = "EquipLevelUp"

event_listener = {
    {CLIENT_EVENT.UPDATE_LEVEL_UP_EQUIP,"onLevelUp"}
}

m_txtName = m_txtName or nil
m_txtPower = m_txtPower or nil
m_panelIcon = m_panelIcon or nil
m_panelNoEquip = m_panelNoEquip or nil
m_scrollView = m_scrollView or nil
m_txtCurLevel = m_txtCurLevel or nil
m_txtNextLevel = m_txtNextLevel or nil
m_panelBaseAttrs = m_panelBaseAttrs or nil
m_panelChangeAttrs = m_panelChangeAttrs or nil
m_sliderEquipExp = m_sliderEquipExp or nil
m_cmptSliderEquipExp = m_cmptSliderEquipExp or nil
m_txtProcess = m_txtProcess or nil
m_btnLevelUp = m_btnLevelUp or nil

m_strEquipId = m_strEquipId or nil
m_dCurLevel = m_dCurLevel or nil
m_dNextLevel = m_dNextLevel or nil
m_dCurExp = m_dCurExp or nil
m_tbConsumeEquip = m_tbConsumeEquip or {}

function init()

    m_tbConsumeEquip = {} 

    local goParent = gameObject.transform:Find("Panel")
    m_panelNoEquip = goParent.transform:Find("NoEquip")
    m_scrollView = goParent.transform:Find("Scroll View/Viewport/Content")
    m_txtName = goParent.transform:Find("EquipingPanel/EquipSelector/Name")
    m_txtPower = goParent.transform:Find("EquipingPanel/EquipSelector/Power")
    m_txtCurLevel = goParent.transform:Find("EquipingPanel/EquipSelector/TxtCurLevel")
    m_txtNextLevel = goParent.transform:Find("EquipingPanel/EquipSelector/TxtNextLevel")
    m_panelIcon = goParent.transform:Find("EquipingPanel/EquipSelector/EquipIcon")
    m_sliderEquipExp = goParent.transform:Find("EquipingPanel/EquipSelector/ExpSlider")
    m_cmptSliderEquipExp = m_sliderEquipExp:GetComponent(UnityEngine.UI.Slider)
    m_txtProcess = goParent.transform:Find("EquipingPanel/EquipSelector/ExpSlider/Process")
    m_panelBaseAttrs = goParent.transform:Find("EquipingPanel/EquipSelector/AttrsPanel/BasePanel")
    m_panelChangeAttrs = goParent.transform:Find("EquipingPanel/EquipSelector/AttrsPanel/ChangePanel")
    m_btnLevelUp = goParent.transform:Find("BtnLevelUp")
end

function resetBaseAttrsItem()
    for i=0, m_panelBaseAttrs.transform.childCount - 1 do
        local goChild = m_panelBaseAttrs.transform:GetChild(i).gameObject
        goChild.gameObject:SetActive(false)
    end
end

function resetChangeAttrsItem()
    for i=0, m_panelChangeAttrs.transform.childCount - 1 do
        local goChild = m_panelChangeAttrs.transform:GetChild(i).gameObject
        goChild.gameObject:SetActive(false)
    end
end

function resetScrollViewItem()
    for i=0, m_scrollView.transform.childCount - 1 do
        local goChild = m_scrollView.transform:GetChild(i).gameObject
        goChild.gameObject:SetActive(false)
        pkgUITool.SetActiveByName(goChild, "Selected", false)
    end
end

function isFullExp(dEquipCfgId)
    local dCurLevel = getAddExp(dEquipCfgId)
    local dCfgMaxLevel = pkgEquipCfgMgr.GetMaxLevel(dEquipCfgId)
    return dCurLevel >= dCfgMaxLevel and true or false
end

function updateExp(dEquipCfgId)
    local dCurLevel, dTestExp = getAddExp(dEquipCfgId)
    local dCfgMaxLevel = pkgEquipCfgMgr.GetMaxLevel(dEquipCfgId)
    print("dCurLevel, dTestExp:", dCurLevel, dTestExp)
    print("dCfgMaxLevel:", dCfgMaxLevel)
    -- 还没满级
    if dCurLevel < dCfgMaxLevel then
        local dNextLevel = dCurLevel + 1
        pkgUITool.UpdateGameObjectText(m_txtCurLevel, 20001, dCurLevel)
        pkgUITool.UpdateGameObjectText(m_txtNextLevel, 20001, dNextLevel)
        updateLevelAttrPanel(m_panelBaseAttrs, dEquipCfgId, dCurLevel)
        updateLevelAttrPanel(m_panelChangeAttrs, dEquipCfgId, dNextLevel)

        local tbLevelUpCfg = pkgEquipCfgMgr.GetLevelUpCfg(dEquipCfgId, dCurLevel)
        local cmptTxt = m_txtProcess:GetComponent(UnityEngine.UI.Text)
        cmptTxt.text = string.format("%d/%d", dTestExp, tbLevelUpCfg.levelUpExp)
        m_cmptSliderEquipExp.value = math.min(dTestExp/tbLevelUpCfg.levelUpExp,1)
    else
        -- 满级了
        pkgUITool.UpdateGameObjectText(m_txtCurLevel, 20001, dCfgMaxLevel - 1)
        pkgUITool.UpdateGameObjectText(m_txtNextLevel, 20001, dCfgMaxLevel)
        updateLevelAttrPanel(m_panelBaseAttrs, dEquipCfgId, dCfgMaxLevel - 1)
        updateLevelAttrPanel(m_panelChangeAttrs, dEquipCfgId, dCfgMaxLevel)

        local tbLevelUpCfg = pkgEquipCfgMgr.GetLevelUpCfg(dEquipCfgId, dCfgMaxLevel - 1)
        local cmptTxt = m_txtProcess:GetComponent(UnityEngine.UI.Text)
        cmptTxt.text = string.format("%d/%d", tbLevelUpCfg.levelUpExp, tbLevelUpCfg.levelUpExp)
        m_cmptSliderEquipExp.value = 1
    end
end

function onLevelUp()
    m_tbConsumeEquip = {}
    show(m_strEquipId)
end

function show(strId)

    m_strEquipId = strId
    
    resetBaseAttrsItem()
    resetChangeAttrsItem()
    resetScrollViewItem()

    local tbEquipInfo = pkgUserDataManager.GetEquip(strId)
    if not tbEquipInfo then
        print("can't not find tbEquipInfo:", strId)
        return
    end

    local dEquipCfgId = tbEquipInfo.cfgId
    local tbGoodsInfo = pkgGoodsCfgMgr.GetGoodsCfg(dEquipCfgId)
    pkgUITool.UpdateGameObjectText(m_txtName, tbGoodsInfo.languageId)

    local strIconName = "icon"
    local icon = m_panelIcon.transform:Find(strIconName)
    if pkgUITool.isNull(icon) then
        pkgUITool.CreateIcon(dEquipCfgId, m_panelIcon, nil, {})
    end

    m_dCurLevel = tbEquipInfo.dLevel
    m_dCurExp = tbEquipInfo.dLevelUpExp

    updateExp(dEquipCfgId)

    updateConsumeEquip(dEquipCfgId)

    local function onClickLevelUp()
        local bIsOk, tbConsumeEquip = canLevelUp(dEquipCfgId)
        if not bIsOk then
            print("No selected equip")
            return
        end

        pkgEquipMgr.LevelUp(strId, tbConsumeEquip)
    end

    pkgButtonMgr.AddBtnListener(m_btnLevelUp, onClickLevelUp)
end

function updateConsumeEquip(dEquipCfgId)
    local tbConsumeEquip = pkgUserDataManager.GetEquipListWithoutId(m_strEquipId)
    if #tbConsumeEquip <= 0 then
        m_panelNoEquip.gameObject:SetActive(true)
        return
    end

    m_panelNoEquip.gameObject:SetActive(false)
    
    for i, tbEquip in ipairs(tbConsumeEquip) do

        local function onClick(goBtn, tbData)
            if isFullExp(dEquipCfgId) and not m_tbConsumeEquip[tbEquip.id].bSelected then
                print("is full exp")
                return
            end
            m_tbConsumeEquip[tbEquip.id].bSelected = not m_tbConsumeEquip[tbEquip.id].bSelected
            pkgUITool.SetActiveByName(goBtn, "Selected", m_tbConsumeEquip[tbEquip.id].bSelected)
            updateExp(dEquipCfgId)
        end

        local function onLoadComplete(goBtn)
            m_tbConsumeEquip[tbEquip.id] = {tbEquip = tbEquip, go = goBtn, bSelected = false}
        end

        local strIconName = tbEquip.id
        local goIcon = m_scrollView.transform:Find(strIconName)
        local tbArgs = {onClick = onClick, iconName = strIconName}
        if pkgUITool.isNull(goIcon) then
            pkgUITool.CreateIcon(tbEquip.cfgId, m_scrollView, onLoadComplete, tbArgs)
        else
            pkgUITool.UpdateIcon(goIcon, tbEquip.cfgId, onLoadComplete, tbArgs)
        end
    end
end

function canLevelUp(dEquipCfgId)
    
    local tbConsumeEquip = {}
    local bSelected = false
    for _, tbEquipInfo in pairs(m_tbConsumeEquip) do
        if tbEquipInfo.bSelected then
            table.insert(tbConsumeEquip,{id = tbEquipInfo.tbEquip.id, count = 1})
        end
    end

    if #tbConsumeEquip <= 0 then
        return false
    end

    return true, tbConsumeEquip
end

function getAddExp(dEquipCfgId)
    local dAddExp = 0
    local tbCfg = nil
    for _, tbEquipInfo in pairs(m_tbConsumeEquip) do
        if tbEquipInfo.bSelected then
            local tbCfg = pkgEquipCfgMgr.GetLevelUpCfg(tbEquipInfo.tbEquip.cfgId, tbEquipInfo.tbEquip.dLevel)
            dAddExp = dAddExp + tbCfg.value
        end
    end
    print("dEquipCfgId, m_dCurLevel, m_dCurExp, dAddExp", dEquipCfgId, m_dCurLevel, m_dCurExp, dAddExp)
    local dMaxLevel, dTestExp = pkgEquipCfgMgr.CalcMaxLevel(dEquipCfgId, m_dCurLevel, m_dCurExp, dAddExp)
    return dMaxLevel, dTestExp
end

function updateLevelAttrPanel(panel, dEquipCfgId, dLevel)
    local tbAttr = pkgEquipCfgMgr.GetLevelUpAttrDescList(dEquipCfgId, dLevel)
    for i, strAttr in ipairs(tbAttr) do
        pkgUITool.SetStringByName(panel, "TextAttr"..i, strAttr)
        pkgUITool.SetActiveByName(panel, "TextAttr"..i, true)
    end
end

function destroyUI()
    
end

function close()
    
end